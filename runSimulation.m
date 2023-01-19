%**************************************************************************************
%Programmer : Arash Nazem 9829333
%Isfahan University of Technology (IUT)
%Teacher : Dr.Taban
%Project : Radar's system first project
%first edition (version 1.0.0.0)
%Title : simulation of a radar with MTI option
%Description:
%   In this project we try to simulate a long rate MTI radar with desired MTI degree
% and desired integration.
%**************************************************************************************

%   Main function that you should enter information here and runs the
%simulator with above information

clear all;
close all;
clc

addpath('Coherent','Detectors','indicator','noise','objects','RF_Band','space','Test_codes');

%****************************************************************
%enter your radar_properties here
radar = Radar_properties;
radar.PRF = .5*10^3;
radar.Ta = 10^-6;
radar.NoisePower = 10^-8;
radar.Carrier = 10^9;
radar.Power = 10^5;
radar.G = 1;
radar.Ae = 5;
radar.IF_Frequency = 5 * 10^6;
radar.sample_rate = 4 * 5 * 10^6;
radar.MTI_order = 1;
radar.Threshold = .5 * 10^-8;
radar.integration_Threshold = 2;
radar.sector_count = 1000;
radar.rotation_frequency = 1/30;
radar.integration_count = 10;
radar.beam_width = 2;

simulation_rotation_count = 30;
%*****************************************************************

%*****************************************************************
%create your targets here
targ1 = space_target;
targ1.name = 'arash2';
targ1.active = 1;
targ1.x = -900;
targ1.y = -1896;
targ1.speed_x = 20;
targ1.speed_y = 3;
targ1.area = 10;
targ1.start_time = 0;
%
targ2 = space_target;
targ2.name = 'arash2';
targ2.active = 1;
targ2.x = 6*15000/sqrt(2);
targ2.y = -6*15000/sqrt(2);
targ2.speed_x = 21/sqrt(2);
targ2.speed_y = -14/sqrt(2);
targ2.area = 10000000000;
targ2.start_time = 0;
%
targ3 = space_target;
targ3.name = 'arash2';
targ3.active = 1;
targ3.x = -8*15000/sqrt(2);
targ3.y = 7*15000/sqrt(2);
targ3.speed_x = 75/sqrt(2);
targ3.speed_y = 0/sqrt(2);
targ3.area = 1000;
targ3.start_time = 0;
%
targ4 = space_target;
targ4.name = 'arash2';
targ4.active = 1;
targ4.x = -5*15000/sqrt(2);
targ4.y = -5*15000/sqrt(2);
targ4.speed_x = 100;
targ4.speed_y = 100;
targ4.area = 10000;
targ4.start_time = 0;
targ4.is_clutter = 0;
targ4.clutter_speedwidth = 0;
%
targ5 = space_target;
targ5.name = 'arash2';
targ5.active = 1;
targ5.x = 5*15000/sqrt(2);
targ5.y = 5*15000/sqrt(2);
targ5.speed_x = -100/sqrt(2);
targ5.speed_y = -100/sqrt(2);
targ5.area = 7000;
targ5.start_time = 0;
%*************************************************************

%**************************************************************
%create the targets array by adding their name into the a array
targs_to_sim=[targ2 targ3 targ4 targ5];
%**************************************************************

out =  space_matrix_creator(radar.sector_count , 1/(radar.PRF*radar.Ta), radar.Ta*enviroment.speedoflihgt/2 , radar.rotation_frequency , simulation_rotation_count, targs_to_sim);
monitor(1,radar.sector_count) = monitor_row;
f1 = figure;

t = 0:1/(radar.sample_rate):(1/radar.PRF-1/(radar.sample_rate));
sin_wave = sin(2*pi*radar.IF_Frequency*t + pi/4);
cos_wave = cos(2*pi*radar.IF_Frequency*t + pi/4);

beam_count = round(radar.beam_width / 180 * radar.sector_count);

for n= 0:length(out)-1-beam_count
    ssrow = Space_row;
    I_total = zeros(radar.integration_count,round(1/radar.PRF/radar.Ta));
    Q_total = I_total;
    
    for i = 0:beam_count - 1
        sr = out(1 , n + i + 1);
        ssrow.target_number = ssrow.target_number + sr.target_number;
        ssrow.targets = [ssrow.targets sr.targets];
    end

    for i = 0:radar.integration_count-1
        noise = wgn(1,radar.sample_rate / radar.PRF , 10*log(radar.NoisePower));
        IF_row = IF_row_Creator(radar,ssrow,n*radar.integration_count+i,noise);
        
        I = InPhase(radar,IF_row,0,sin_wave);
        Q = Quad(radar,IF_row,0,cos_wave);
        
        ID = downsample(I,radar.sample_rate*radar.Ta);
        QD = downsample(Q,radar.sample_rate*radar.Ta);
        I_total(i+1,:) = ID;
        Q_total(i+1,:) = QD;
    end
    
    IM = MTI(I_total);
    QM = MTI(Q_total);

    if radar.MTI_order > 1
        for i = 1:radar.MTI_order-1
            IM = MTI(IM);
            QM = MTI(QM);
        end
    end
    
    detection = zeros(radar.integration_count-radar.MTI_order,1/(radar.PRF*radar.Ta));
    for i = 1:radar.integration_count-radar.MTI_order
        detection(i,:) = CoherentEnergyDetector(IM(i,:),QM(i,:),radar.Threshold);
    end
    integrated = zeros(1,round(1/radar.PRF/radar.Ta));
    for i = 1:radar.integration_count-radar.MTI_order
        integrated = integrated + detection(i,:);
    end
    detintegrated = zeros(1,round(1/radar.PRF/radar.Ta));
    for i = 1:round(1/radar.PRF/radar.Ta)
        if integrated(1,i) > radar.integration_Threshold
            detintegrated(1,i) = 1;
        end
    end
    
    r = monitor_row;
    distances(1,:) = 0;
    for i = 1:length(detintegrated)
        if detintegrated(1,i) == 1 
            r.count = r.count + 1;
            distances(1,r.count) = i;
            display(i);
        end
    end
    r.targs = distances;
    monitor(1,mod(n,radar.sector_count)+1) = r;
    
    if (mod(n,8) == 0)
        total_targs = 0;
        targs_on_disp(1,:) = 0;
        for phic = 1:length(monitor)
            ro = monitor(1,phic);
            if ro.count > 0
                for rc = 1:ro.count
                    total_targs = total_targs + 1;
                    targs_on_disp(1,total_targs) = ro.targs(rc) * cos(2*pi*phic/radar.sector_count) + 1i*ro.targs(rc) * sin(2*pi*phic/radar.sector_count);
                end
            end
        end
    
        figure(f1);
        p=polarplot(targs_on_disp,'*',[2*pi*mod(n,radar.sector_count)/radar.sector_count 2*pi*mod(n,radar.sector_count)/radar.sector_count],[0 round(1/radar.PRF/radar.Ta)],'Color','r');
        set(p,'Color',[0.4667 0.6745 0.1882]);
    end
end