%% Documentation
% 
% Authors:      Alexander Wischnewski (alexander.wischnewski@tum.de) 
% 
% Start Date:   26.01.2019
% 
% Description:  controls startup process when passenger vehicle project is
%               loaded.  

%% General stuff 
% reset current settings for generated files 
Simulink.fileGenControl('reset')
% clean up workspace 
close all; 
clear all; 
% create project handles
project = simulinkproject;
projectRoot = project.RootFolder;


%% create build folder 
try
    % check if build folder exists and clean it up
    if(exist([projectRoot '/build'], 'dir'))
        rmdir([projectRoot '/build'], 's'); 
    end
    % create an empty build directory 
    mkdir([projectRoot '/build']); 
    disp('Build folder setup done.'); 
catch e
    disp('Exception: ');
    disp(getReport(e))
    error('Setup of build folder failed.'); 
end
% set build folder as target for code generation and cache files 
myCacheFolder = fullfile(projectRoot, 'build');
myCodeFolder = fullfile(projectRoot, 'build');
Simulink.fileGenControl('set',...
    'CacheFolder', myCacheFolder,...
    'CodeGenFolder', myCodeFolder,...
    'createDir', true)

%% configure models for passenger vehicle 
try 
    % configure vehicle dynamics control 
    configureVDCModule('pa'); 
    configureVDCBuildModelConfig('GRT'); 
    % configure vehicle dynamics simulation 
    configureSimBuildModelConfig('GRT'); 
    % configure scenario 
    loadScenario('Berlin2018'); 
catch e
    disp('Exception: ');
    disp(getReport(e))
    error('Error during parameter configuration'); 
end