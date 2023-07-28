
function [spikes] = getCSVCells(varargin)
% Load brian2 simulated neurons
%
% USAGE
%
%   [spikes] = getCSVCells(varargin)
%
% INPUTS
%
% basepath        -path to cvs files
% cvsFiles        -CSVs files list (cell{})
% saveMat         -logical (default=true) to save in buzcode format
% forceReload     -logical (default=false) to force loading from
% cellsInCSV      -number of cells simulated in each CSV file (example, [800, 200])
%
% OUTPUTS
%
% spikes - cellinfo struct with the following fields
%   .sessionName    -name of recording file
%   .UID            -unique identifier for each neuron in a recording
%   .times          -cell array of timestamps (seconds) for each neuron
%   .spindices      -sorted vector of [spiketime UID], useful for 
%                           input to some functions and plotting rasters
%   .subgroup       -Files subgroup number 
%   .subgroupId     -Pair number-identifier on file name, if present (for example, "I" in spk_I.cvs for inhibitory cells)
%
%  HISTORY:
%  10/2019  Manu Valero
%  Include 

%% Parse options
p = inputParser;
addParameter(p,'basepath',pwd,@isstr);
addParameter(p,'cvsFiles',[],@iscell);
addParameter(p,'saveMat',true,@islogical)
addParameter(p,'forceReload',false,@islogical);
addParameter(p,'cellsInCSV',false,@isnumeric);

parse(p,varargin{:});

basepath = p.Results.basepath;
saveMat = p.Results.saveMat;
csvFiles = p.Results.cvsFiles;
sessionName = strsplit(pwd,filesep);
sessionName = sessionName{end};
forceReload = p.Results.forceReload;
cellsInCSV = p.Results.cellsInCSV;

if exist([basepath filesep sessionName '.spikes.cellinfo.mat'],'file') && forceReload == false
    load([basepath filesep sessionName '.spikes.cellinfo.mat']);
else
    pwdNow = pwd;
    cd(basepath)
    ident = [];
    if isempty(csvFiles) && isempty(dir('*spk*.csv'))
        error('No cvs files to read!! ');
    elseif isempty(csvFiles)
        files = dir('*spk*.csv');
        for ii = 1:size(files,1)
            csvFiles{ii} = [files(ii).folder filesep files(ii).name];
            temp = strsplit(files(ii).name,'.');
            ident{ii} = temp{1}(end);
        end
    end
    
    if isempty(cellsInCSV)
        for ii = 1:size(csvFiles,2)
            fileSpikes = readmatrix(csvFiles{ii});
            cellsInCSV(ii) = max(unique(fileSpikes(1,:))) + 1;
        end
    end

    % get cells
    disp('Loading data...');
    kk = 1;
    for ii = 1:length(cellsInCSV)
        fprintf(' ** file %3.i of %3.i  \n', ii, size(csvFiles,2));
        fileSpikes = readmatrix(csvFiles{ii});
        for jj = 1:cellsInCSV(ii)
            spikes.times{kk}= fileSpikes(2,find(fileSpikes(1,:) == jj))'/1000; % in seconds
            spikes.UID(kk) = kk;
            spikes.subgroup(kk) = ii;
            spikes.shankID(kk) = 1;
            kk = kk + 1;
        end
    end

    for ii = 1:size(ident,2)
        spikes.subgroupID{1,ii} = ident{ii};
        spikes.subgroupID{2,ii} = ii;
    end

    for cc = 1:length(spikes.UID)
        groups{cc}=spikes.UID(cc).*ones(size(spikes.times{cc}));
    end
    if ~isempty(spikes.UID)
        alltimes = cat(1,spikes.times{:}); groups = cat(1,groups{:}); %from cell to array
        [alltimes,sortidx] = sort(alltimes); groups = groups(sortidx); %sort both
        spikes.spindices = [alltimes groups];
    end

    if saveMat
        save([basepath filesep sessionName '.spikes.cellinfo.mat'],'spikes');
    end
    cd(pwdNow);
end

end