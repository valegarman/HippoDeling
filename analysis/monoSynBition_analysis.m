% monoSynBition_analysis
% Manu 2023

padding_opotogenetic_pulse = 0.1;
winSize = 0.2;
binSize = 0.001;
cd("C:\Users\mvalero\Dropbox\DATA\monoSynBition_models\");
all_simulations = dir;

simulations_results = [];
parfor ii = 3:length(all_simulations)
    
    cd([all_simulations(ii).folder filesep all_simulations(ii).name])
    spikes = getCSVCells('cvsFiles',{'spk_E.csv', 'spk_I.csv'}, 'cellsInCSV', [800, 200]); % load simulation
    
    features = readmatrix('features.csv');% load features
    session = getSession_simulation(features, spikes, padding_opotogenetic_pulse);
    
    uLEDPulses = getuLEDPulses_simulation(session)
    
    sessionName = strsplit(pwd,filesep);
    sessionName = sessionName{end};
    parsave([pwd filesep sessionName '.uLEDPulses.event.mat'],'uLEDPulses');
    
    % compute pulses amplitude
    uLEDResponses_interval = getuLEDResponse_intervals([session.inhibition_times - 0.01 session.inhibition_times + 0.01],'spikes',spikes,'uLEDPulses',uLEDPulses,'doPlot', false);

    simulations_results(ii).uLEDResponses_interval = uLEDResponses_interval;
    simulations_results(ii).uLEDPulses = uLEDPulses;
    simulations_results(ii).session = session;
    simulations_results(ii).spikes = spikes;

end





