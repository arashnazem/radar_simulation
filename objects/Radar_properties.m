classdef Radar_properties
    properties
        PRF {mustBeNumeric}
        Ta {mustBeNumeric}
        NoisePower {mustBeNumeric}
        Carrier {mustBeNumeric}
        Power {mustBeNumeric}
        G {mustBeNumeric}
        Ae {mustBeNumeric}
        IF_Frequency {mustBeNumeric}
        sample_rate {mustBeNumeric}
        integration_count {mustBeNumeric}
        MTI_order {mustBeNumeric}
        Threshold {mustBeNumeric}
        integration_Threshold {mustBeNumeric}
        sector_count {mustBeNumeric}
        rotation_frequency {mustBeNumeric}
        beam_width {mustBeNumeric}
    end
end