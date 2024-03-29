detector = peopleDetectorACF();
img=imread('visionteam.jpg');
[bboxes,scores] = detect(detector,img);
%I = insertObjectAnnotation(img,'rectangle',bboxes,scores);
%imshow(img);
for i=2:size(bboxes,1)
    dis1_v = abs(bboxes(1,1)+bboxes(1,3)-bboxes(i,1));
    dis2_v = abs(bboxes(i,1)+bboxes(i,3)-bboxes(1,1));
    dis1_h = abs(bboxes(1,2)+-bboxes(i,2));
    dis2_h = abs(bboxes(1,2)+bboxes(1,4)-bboxes(i,2)-bboxes(i,4));
    if((dis1_v<75 || dis2_v<75)&&(dis1_h<50 || dis2_h<50))
        img=insertObjectAnnotation(img,'rectangle',bboxes(i,:),i,'color','r');
    else
        img=insertObjectAnnotation(img,'rectangle',bboxes(i,:),i,'color','g');
    end
end
imshow(img);
%% video player
videoReader = vision.VideoFileReader('vtest.avi');
videoPlayer = vision.VideoPlayer('Position',[300 100 1000 500]);
detector = peopleDetectorACF('caltech-50x21');
while ~isDone(videoReader)
    frame = step(videoReader);
    img=double(frame);
    [bboxes,scores] = detect(detector,img);
    cond = zeros(size(bboxes,1),1);
    if ~isempty(bboxes)
        for i=1:(size(bboxes,1)-1)
            for j=(i+1):(size(bboxes,1)-1)
                    dis1_v = abs(bboxes(i,1)+bboxes(i,3)-bboxes(j,1));
                    dis2_v = abs(bboxes(j,1)+bboxes(j,3)-bboxes(i,1));
                    dis1_h = abs(bboxes(i,2)+-bboxes(j,2));
                    dis2_h = abs(bboxes(i,2)+bboxes(i,4)-bboxes(j,2)-bboxes(j,4));
                    if((dis1_v<75 || dis2_v<75)&&(dis1_h<50 || dis2_h<50))
                        cond(i)=cond(i)+1;
                        cond(j)=cond(j)+1;
                    else
                        cond(i)=cond(i)+0;
                    end
            end
        end
    end
   img = insertObjectAnnotation(img,'rectangle',bboxes((cond>0),:),'danger','color','r');
   img = insertObjectAnnotation(img,'rectangle',bboxes((cond==0),:),'safe','color','g');
   step(videoPlayer,img);
end
release(videoReader);
release(videoPlayer);

