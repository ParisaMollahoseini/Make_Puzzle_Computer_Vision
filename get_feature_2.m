function feature_img = get_feature_2(img,str)

switch str
    case "img"
        feature_img = [img(:,:,1),img(:,:,2),img(:,:,3)]/max(max(max(img(:,:,:))));
    case "ave"
        feature_img = sum(sum(img(:,:)))/numel(img);
    case "hist"
        feature_img = imhist(img);
    case "ave_color"
        imgr = img(:,:,1);
        imgg = img(:,:,2);
        imgb = img(:,:,3);
        feature_img = [sum(sum(imgr(:,:)))/numel(imgr),sum(sum(imgg(:,:)))/numel(imgg),sum(sum(imgb(:,:)))/numel(imgb)];
       
    case "hist_color"
        imgr = img(:,:,1);
        imgg = img(:,:,2);
        imgb = img(:,:,3);
        feature_img = [imhist(imgr);imhist(imgg);imhist(imgb)];
        feature_img = feature_img/max(feature_img);
    case "HOG"
        feature_img = extractHOGFeatures(img);
    case "imgradient"
        [gmag_r,gdir_r] = imgradient(img(:,:,1));
        gdir_r = gdir_r/max(gdir_r);
        gmag_r = gmag_r/max(gmag_r);
        
        [gmag_g,gdir_g] = imgradient(img(:,:,2));
        gdir_g = gdir_g/max(gdir_g);
        gmag_g = gmag_g/max(gmag_g);
        
        [gmag_b,gdir_b] = imgradient(img(:,:,3));
        gdir_b = gdir_b/max(gdir_b);
        gmag_b = gmag_b/max(gmag_b);
        
        feature_img = [gmag_r,gdir_r,gmag_g,gdir_g,gmag_b,gdir_b];
    case "LBP"
        feature_img = [extractLBPFeatures(img(:,:,1)),extractLBPFeatures(img(:,:,2)),extractLBPFeatures(img(:,:,3))];
        feature_img = feature_img/max(feature_img);
        
end


end