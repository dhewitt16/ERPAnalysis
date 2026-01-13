%% This script imports BrainProducts EEG files in to EEGLAB and saves as .set files for preprocessing
% Dependencies: EEGLAB on path with BrainProducts import plugin installed
% Set directories for EEGLAB and data files
% Danielle Hewitt, 4th November 2024

% After generating the files, open the resulting .set file in EEGLAB to
% ensure that event triggers loaded successfully. there should be 90 or more (one
% for each onset and offset, plus practice trials). Make sure to install
% the BDFimport plugin before running.

%Set path for EEGLAB
eeglab_path = '/Users/dhewitt/Analysis/eeglab2022.1/'; %% change to match your setup
addpath(genpath(eeglab_path));

%Specify subjects and main directory where data is stored
%subjects = {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17','18','19','20','21','22','23','24','25'}; %loops through all pts
subjects = {'05'}; %if just doing one participant
mainDirectory = '/Users/dhewitt/Data/Touch/CE-UK-Collaboration/'; %% change this directory to match wehre the data is stored on your pc

[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

% Looping over all subjects
for i = 1:size(subjects,2)
    currentSubject = subjects{i};

    % Looping over all EEG files
    currentDirectory = [mainDirectory 'T2_' currentSubject '/'];
    EEGfiles =  dir(fullfile(currentDirectory, '*.bdf')); %finding all EEG files in subject folder
    for j = 1:length(EEGfiles)
        currentEEGFile = EEGfiles(j).name; %defining current EEG file for import

        % Getting name of current file to make setname
        setfiles = split(currentEEGFile, '.'); % removing the extension
        setName = char([setfiles(1)]);

        % Load into EEGLAB and save as .set file
        %EEG = pop_biosig([currentDirectory currentEEGFile],'ref',1); %% this one doesn't work well for biosemi
        EEG = pop_readbdf([currentDirectory currentEEGFile],[],65,1);
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',setName,'gui','off');
        eeglab redraw
        EEG = eeg_checkset( EEG );
        EEG = pop_saveset( EEG, 'filename',[setName '.set'],'filepath',currentDirectory);
        [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
        STUDY = []; CURRENTSTUDY = 0; ALLEEG = []; EEG=[]; CURRENTSET=[];

        disp(['Saved: ' currentEEGFile])

    end

end

disp('All done!'); %% if no files are generated, check the path is correct
