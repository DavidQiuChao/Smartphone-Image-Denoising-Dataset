%% dependencies

addpath(fullfile(pwd, 'camera_pipeline_simple'));
addpath(fullfile(pwd, 'RBF_ThinPlate_image_warping'));
addpath(fullfile(pwd, 'efficient_subpixel_registration'));


%% data and parameters (replace with your preferences)

outroot = '/media/tcl2/darkshot/qiuchao/data/T1_150_res';
root = '/media/tcl1/darkshot/dataset/T1_150/';

addpath(root)
addpath(outroot)

%dngDirs = GetFolders(root);
name = 'ok'
dngDirs= RemainDirs(name);

defectivePixelsMask = load(fullfile(pwd, 'black/badPixel.mat')); 
defectivePixelsMask = logical(defectivePixelsMask.x);
% if not available, use an empty array
refIdx = 1; % use first image as reference for spatial alignment

%% prepare parallel pool

NUM_WORKERS = 16;
prepare_parallel_pool(NUM_WORKERS);


for i= 1 : numel(dngDirs)
    dngDir = dngDirs{i};
    fprintf(['start scene:',dngDir]);

    %% ground truth image estimation
    
    [MeanUnprocessed, AlignedMeanImage, RobustMeanImage, ...
        MeanUnprocessedSrgb, AlignedMeanImageSrgb, RobustMeanImageSrgb, ...
        refImage, refImageSrgb, refMetadata] ...
        = EstimateGroundTruthImage(dngDir, defectivePixelsMask, refIdx);
    
    %% saving outputs
    dngDir = strsplit(dngDir,'/');
    dngDir = dngDir{length(dngDir)};
    if ~exist(fullfile(outroot,dngDir),'dir')
        mkdir(fullfile(outroot,dngDir));
    end
    
    parsave(fullfile(outroot, dngDir, 'MeanUnprocessed.mat'), MeanUnprocessed);
    parsave(fullfile(outroot, dngDir, 'AlignedMeanImage.mat'), AlignedMeanImage);
    parsave(fullfile(outroot, dngDir, 'GT_RAW.mat'), RobustMeanImage);
    
    imwrite(MeanUnprocessedSrgb, ...
        fullfile(outroot, dngDir, 'MeanUnprocessedSrgb.png'));
    imwrite(AlignedMeanImageSrgb, ...
        fullfile(outroot, dngDir, 'AlignedMeanImageSrgb.png'));
    imwrite(RobustMeanImageSrgb, ...
        fullfile( outroot, dngDir, 'GT_SRGB.png'));
    
    parsave(fullfile(outroot, dngDir, 'NOISY_RAW.mat'), refImage);
    imwrite(refImageSrgb, fullfile(outroot, dngDir, 'NOISY_SRGB.png'));
    parsave(fullfile(outroot, dngDir, 'METADATA_RAW.mat'), refMetadata);
    fprintf(['scene:',dngDir,'finish']);

end
