
function session = getSession_simulation(features, spikes, padding_opotogenetic_pulse)
    session.N_excitatory_units = features(1); % N_E
    session.N_inhibitory_units = features(2); % N_I
    session.N_probed_units = features(3); % N_E_probed
    session.probed_units = spikes.UID(1:features(3));
    session.duration = features(4); % duration
    session.V_leakage = features(5); % V_L
    session.V_threshold_excitatory_units = features(6); % V_thr_E
    session.V_threshold_inhibitory_units = features(7); % V_thr_I
    session.V_reset = features(8); % V_reset
    session.V_reversal_excitation = features(9); % V_E
    session.V_reversal_inhibition = features(10); % V_I
    session.capacitance_excitatory_units = features(11); % C_m_E
    session.capacitance_inhibitory_units = features(12); % C_m_I
    session.conductance_excitation = features(13); % g_m_e
    session.conductance_inhibition = features(14); % g_m_I
    session.tau_excitation = features(15); % tau_rp_E
    session.tau_inhibition = features(16); % tau_rp_I
    session.rate_poisson_noise = features(17); % tau_rp_I
    session.N_incomming_units = features(18); % C_ext
    session.GABA_conductance = 1.25 * features(19); % GABA_factor_steps
    session.optogenetic_pulse_amplitude = features(20); % probing_steps
    session.optogenetic_pulse_duration = 0.02; % missing in the model 07/25/23
    
    session.inhibition_times = readmatrix("inhibition_times.csv")/1000;
    session.probing_times = readmatrix("probing_times.csv")/1000;
    [status, intervals] = InIntervals(session.inhibition_times, [session.probing_times - padding_opotogenetic_pulse ...
        session.probing_times + session.optogenetic_pulse_duration + padding_opotogenetic_pulse]);
    intervals = unique(intervals); intervals(intervals==0) = [];
    session.probing_times_with_inhibition = session.probing_times(intervals);
    session.probing_times_without_inhibition = session.probing_times;
    session.probing_times_without_inhibition(intervals) = [];
    session.inhibition_times_without_pulse = session.inhibition_times(status==0);

end