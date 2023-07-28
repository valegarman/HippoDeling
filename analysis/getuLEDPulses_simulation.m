
function uLEDPulses = getuLEDPulses_simulation(session)

uLEDPulses.timestamps = [session.probing_times session.probing_times];
uLEDPulses.code = ones(size(uLEDPulses.timestamps,1),1);
uLEDPulses.conditionID = ones(size(uLEDPulses.timestamps,1),1);
uLEDPulses.conditionDurationID = 1;
uLEDPulses.conditionDuration = session.optogenetic_pulse_duration;
uLEDPulses.nonStimulatedShank = NaN;

end