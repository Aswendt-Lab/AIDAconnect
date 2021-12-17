function fsl_mean_ts(inputPath,maskPath)

% Read 4D data file (NIfTI)
data_img = load_nii(inputPath);
data = double(data_img.img);
data = flip(data,1);
data_hdr = data_img.hdr.dime;
data_shape = data_hdr.dim;
 
if data_shape(1) ~= 4
     error("Error: data is not 4D shape.")
end

% Read 4D mask file (NIfTI)
mask_img = load_nii(maskPath);
mask = double(mask_img.img);
%mask = flip(mask,1);
mask_hdr = mask_img.hdr.dime;
mask_shape = mask_hdr.dim;

if mask_shape(1) ~= 4
     error("Error: mask is not 4D shape.")
end
if data_shape(1:4) ~= mask_shape(1:4)
     error("Error: data and mask are not the same shape.")
end

m = zeros(mask_shape(5), data_shape(5));
for k=1:mask_shape(5)
    fprintf('|')
    msk = mask(:,:,:,k)>0;
    dataMsk = zeros(sum(msk(:)>0),data_shape(5));
    for j=1:data_shape(5)
        dataT = data(:,:,:,j);
        dataMsk(:,j) = dataT(msk);
    end
    m(k,:) = mean(dataMsk);
end
disp('Done!');
m(isnan(m)) = 0.0;

[filepath,name] = fileparts(inputPath);
name = split(name,'.');
name = name{1};

outputStr = fullfile(filepath,['MasksTCs.' name '.txt']);
dlmwrite(outputStr,m','delimiter',' ','precision','%.4f')

end

