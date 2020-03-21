
imageNames = dir('*.jpg');
imageNames = {imageNames.name}';
outputVideo = VideoWriter(fullfile('shuttle_out.avi'));
open(outputVideo)

for ii = 1:length(imageNames)
   img = imread(fullfile(imageNames{ii}));
   writeVideo(outputVideo,img)
end

close(outputVideo)

shuttleAvi = VideoReader(fullfile('shuttle_out.avi'));

images    = cell(2,1);

images{1} = imread('img001.jpg');
images{2} = imread('img002.jpg');
images{1}=imresize(images{1}, [634 2076]);
images{2}=imresize(images{2}, [634 2076]);
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 1;
secsPerImage = [5 10];
open(writerObj);

for u=1:length(images)
     % convert the image to a frame
     frame = im2frame(images{u});
     for v=1:secsPerImage(u) 
        writeVideo(writerObj, frame);
     end
end
close(writerObj)

clc
clear

images{1} = imread('img001.jpg');
images{2} = imread('img002.jpg');
images{1}=imresize(images{1}, [634 2076]);
images{2}=imresize(images{2}, [634 2076]);
writerObj = VideoWriter('myVideo.avi');
writerObj.FrameRate = 0.5;
secsPerImage = [5 10];
open(writerObj);
for u=1:length(images)
     % convert the image to a frame
     frame = im2frame(images{u}); 
     writeVideo(writerObj, frame);
end
close(writerObj)
