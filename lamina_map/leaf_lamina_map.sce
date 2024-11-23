// Leaf Lamina Map version 1.0
// Color index methodology - Dr. Péter Bodor-Pesti
// Computer Vision - Dr. László Baranyai, lbaranyai@github

// Main Application Window
f = figure("figure_size", [1000 702],"figure_name", "Lamina Map v1.0","dockable","off","infobar_visible","off","toolbar_visible","off","menubar_visible","off","default_axes","on","auto_resize","on","backgroundcolor",[0.8,0.8,0.8]);

// Application session
handles.dummy = 0;
handles.txtSign = uicontrol(f,"style","text","string","Creative Commons CC-BY-NC (2024) L. Baranyai & P. Bodor-Pesti","units","normalized","position",[0.02 0.02 0.44 0.04],"backgroundcolor",[0.8,0.8,0.8],"foregroundcolor",[0.4 0.4 0.4],"horizontalalignment","center");
// Picture area
handles.myPicture = newaxes();
handles.myPicture.margins = [0 0 0 0];
handles.myPicture.axes_bounds = [0.49 0 0.51 1];
handles.myPicture.auto_clear = "on";
//
// Picture data
//
// Original color picture
handles.PIC = zeros(1,1,3);
// Mask for background
handles.PMask = zeros(1,1);
// Transformed data
handles.PData = zeros(1,1);
// Transformed data range
handles.PRange = [0 1];
// Gray image for saving file
handles.SPIC = zeros(1,1);
// Data for saving
handles.SData = [1 2 3 4 5];
// File name
handles.FName = 'x';
// List of file types
handles.PicTypes = ["Original",...
"Red chromacity","Green chromacity","Blue chromacity",...
"RMG (Difference between red and green)","RMB (Difference between red and blue)","GMB (Difference between green and blue)",...
"NRGVI (Normalized red-green difference index)","NRBVI (Normalized red-blue difference index)","NGBVI (Normalized green-blue difference index)","NGRVI (Normalized green-red difference index)","NBRVI (Normalized blue-red difference index)","NBGVI (Normalized blue-green difference index)",...
"WI (Woebbecke Index)","BI (Brightness Index)",...
"RGCh (Red-Green Chromaticity)","RBCh (Red-Blue Chromaticity)","GBCh (Green-Blue Chromaticity)","GRCh (Green-Red Chromaticity)","BRCh (Blue-Red Chromaticity)","BGCh (Blue-Green Chromaticity)",...
"MGRVI (Modified Green-Red Vegeation Index)","RGRI (Red-Green Ratio Index)","BGRI (Blue-Green Ratio Index)","GLI (Green leaf index)","VARI (Visible atmospherically resistance index)",...
"ExR (Excess red vegetation index)","ExG (Excess green vegetation index)","ExB (Excess blue vegetation index)","ExGR (Excess green-Excess red)"];

// User controls
handles.pbOpen = uicontrol(f,"style","pushbutton","string","Open picture","units","normalized","position",[0.02 0.9 0.2 0.06],"callback","fnOpen(handles)");
handles.pbCapture = uicontrol(f,"style","pushbutton","string","Capture image","units","normalized","position",[0.26 0.9 0.2 0.06],"callback","fnCapture(handles)");
handles.pbSave = uicontrol(f,"style","pushbutton","string","Save image","units","normalized","position",[0.26 0.16 0.2 0.06],"callback","fnSavePicture(handles)","enable","off");
handles.pbScan = uicontrol(f,"style","pushbutton","string","Scan and save","units","normalized","position",[0.02 0.16 0.2 0.06],"callback","fnSaveAllData(handles)","enable","off");
handles.txtFile = uicontrol(f,"style","text","string","File:","units","normalized","position",[0.02 0.85 0.44 0.04],"backgroundcolor",[0.8,0.8,0.8]);
handles.txtPicType = uicontrol(f,"style","text","string","Choose image type","units","normalized","position",[0.02 0.82 0.44 0.04],"backgroundcolor",[0.8,0.8,0.8]);
handles.lbPicType = uicontrol(f,"style","listbox","units","normalized","position",[0.02 0.42 0.44 0.4],"string",handles.PicTypes,"value",[1],"callback","GetCMap(handles)","enable","off");
handles.cbScale = uicontrol(f,"style","checkbox","string","Autoscale","units","normalized","position",[0.02 0.37 0.44 0.04],"min",[0],"max",[1],"value",[0],"callback","ShowPicture(handles)","backgroundcolor",[0.8,0.8,0.8],"enable","off");
// report results on screen
handles.txtMean = uicontrol(f,"style","text","string","Average:","units","normalized","position",[0.02 0.32 0.09 0.04],"backgroundcolor",[0.8,0.8,0.8],"horizontalalignment","right");
handles.txtStdev = uicontrol(f,"style","text","string","Deviation:","units","normalized","position",[0.02 0.28 0.09 0.04],"backgroundcolor",[0.8,0.8,0.8],"horizontalalignment","right");
handles.txtContrast = uicontrol(f,"style","text","string","Contrast:","units","normalized","position",[0.26 0.32 0.09 0.04],"backgroundcolor",[0.8,0.8,0.8],"horizontalalignment","right");
handles.txtEnergy = uicontrol(f,"style","text","string","Energy:","units","normalized","position",[0.26 0.28 0.09 0.04],"backgroundcolor",[0.8,0.8,0.8],"horizontalalignment","right");
handles.txtEntropy = uicontrol(f,"style","text","string","Entropy:","units","normalized","position",[0.26 0.24 0.09 0.04],"backgroundcolor",[0.8,0.8,0.8],"horizontalalignment","right");
handles.edMean = uicontrol(f,"style","edit","string","n/a","units","normalized","position",[0.12 0.32 0.1 0.04],"enable","off","horizontalalignment","right");
handles.edStdev = uicontrol(f,"style","edit","string","n/a","units","normalized","position",[0.12 0.28 0.1 0.04],"enable","off","horizontalalignment","right");
handles.edContrast = uicontrol(f,"style","edit","string","n/a","units","normalized","position",[0.36 0.32 0.1 0.04],"enable","off","horizontalalignment","right");
handles.edEnergy = uicontrol(f,"style","edit","string","n/a","units","normalized","position",[0.36 0.28 0.1 0.04],"enable","off","horizontalalignment","right");
handles.edEntropy = uicontrol(f,"style","edit","string","n/a","units","normalized","position",[0.36 0.24 0.1 0.04],"enable","off","horizontalalignment","right");

handles.hProgress = uicontrol(f,"style","text","string","","units","normalized","position",[0.02 0.11 0.44 0.04],"backgroundcolor",[0.8,0.8,0.8],"foregroundcolor",[0.4 0.4 0.4],"horizontalalignment","center");

//
// Functions
//

// Capture image
function fnCapture(handles)
    try
        // Capture on camera ID = 0
        n = camopen(0);
        tmp = camread(n);
        camcloseall();
        // Save to session and adjust UI
        handles.PIC = tmp;
        handles.FName = "capture.jpg";
        handles.txtFile.string = "File: (captured)";
        handles.lbPicType.enable = "on";
        handles.cbScale.enable = "on";
        handles.pbSave.enable = "on";
        handles.pbScan.enable = "on";
        ResetData(handles);
    catch
        // In case of error
        [em,ec] = lasterror(%T);
        messagebox(em,"Error","error","modal");
    end
    handles = resume(handles);
endfunction

// Open picture file
function fnOpen(handles)
    // Only JPEG pictures are expected from scanner or camera
    [FileName,PathName,FilterIndex] = uigetfile(["*.jpg|*.jpeg|*.JPG|*.JPEG", "JPEG pictures"]);
    if FilterIndex == 0 then
        messagebox("No file was selected.","Open","warning","modal");
    else
        // Read image data
        tmp = imread(fullfile(PathName, FileName));
        handles.PIC = tmp;
        // Save filename to session and adjust UI
        handles.FName = fullfile(PathName, FileName);
        handles.txtFile.string = msprintf("File: %s",FileName);
        handles.lbPicType.enable = "on";
        handles.cbScale.enable = "on";
        handles.pbSave.enable = "on";
        handles.pbScan.enable = "on";
        ResetData(handles);
    end
    handles = resume(handles);
endfunction

// Save transformed image
function fnSavePicture(handles)
    // Save only transformed, not the original
    if handles.lbPicType.value > 1 then
        // New name is created with the order number of the transformation
        newName = msprintf("%s-%d.jpg",handles.FName,handles.lbPicType.value);
        imwrite(handles.SPIC,newName);
        messagebox(newName,"Save","info","modal");
    else
        messagebox("The original picture is kept. No new version saved.","Save","warning","modal");
    end
    handles = resume(handles);
endfunction

// Reset all data to default
function ResetData(handles)
    // New mask is created with Otsu's threshold. White background is assumed.
    th = imgraythresh(handles.PIC);
    handles.PMask = im2bw(handles.PIC,th);
    // Apply transformation on image data
    GetCMap(handles);
    handles = resume(handles);
endfunction

// Show picture and compute parameters
function ShowPicture(handles)
    if handles.lbPicType.value == 1 then
        // If original picture is requested, no data is calculated
        imshow(handles.PIC);
        handles.edMean.string = "n/a";
        handles.edStdev.string = "n/a";
        handles.edContrast.string = "n/a";
        handles.edEnergy.string = "n/a";
        handles.edEntropy.string = "n/a";
    else
        // Use transformed data of the leaf surface
        tmp = handles.PData;
        tmp2 = tmp(handles.PMask == %F);
        // Container for results
        dv = zeros(1,5);
        // Calculation of parameters
        dv(1) = mean(tmp2);
        dv(2) = stdev(tmp2);
        handles.edMean.string = msprintf("%.4f",dv(1));
        handles.edStdev.string = msprintf("%.4f",dv(2));
        // Get normalized histogram with 50 elements
        hn = histc(tmp2,50,'countsNorm');
        // Calculate bin values for contrast computation
        hc = 1:length(hn);
        hc = min(tmp2) + (hc  - 1).*(max(tmp2) - min(tmp2))/length(hn);
        // Calculation of parameters
        for i = 1:length(hn)
            dv(3) = dv(3) +  hn(i)*hc(i)^2; // contrast
            dv(4) = dv(4) +  hn(i)^2; // energy
            if hn(i) > 0 then
                dv(5) = dv(5) + hn(i)*log10(hn(i)); // entropy
            end
        end
        handles.edContrast.string = msprintf("%.4f",dv(3));
        handles.edEnergy.string = msprintf("%.4f",dv(4));
        handles.edEntropy.string = msprintf("%.4f",dv(5));
        // Save results
        handles.SData = dv;
        // Adjust data to 0-255 scale to show
        rv = handles.PRange;
        // If autoscale, apply image data range
        if handles.cbScale.value == 1 then
           rv(1) = min(tmp2);
           rv(2) = max(tmp2);
        end
        tmp = 255*(tmp - rv(1))/(rv(2) - rv(1));
        // Background is masked to white
        tmp(handles.PMask == %T) = 255;
        tmp = uint8(tmp);
        imshow(tmp);
        handles.SPIC = tmp;
    end
    handles = resume(handles);
endfunction

// Calculate color maps
function GetCMap(handles)
    // Failsafe check
    Layers = 0;
    [Height,Width,Layers] = size(handles.PIC);
    if Layers ~= 3 then
        messagebox("Non-color image matrix.","Error","error","modal");
        return -1;
    end
    // Prepare channels
    pr = double(handles.PIC(:,:,1));
    pg = double(handles.PIC(:,:,2));
    pb = double(handles.PIC(:,:,3));
    // Choose option
    select handles.lbPicType.value
    case 1 then
        // Original color picture
        handles.PData = handles.PIC;
    case 2 then
        // Red chromacity
        ss = pr + pg + pb;
        ss(ss==0) = 1;
        handles.PData = pr ./ ss;
        handles.PRange = [0 1];
    case 3 then
        // Green chromacity
        ss = pr + pg + pb;
        ss(ss==0) = 1;
        handles.PData = pg ./ ss;
        handles.PRange = [0 1];
    case 4 then
        // Blue chromacity
        ss = pr + pg + pb;
        ss(ss==0) = 1;
        handles.PData = pb ./ ss;
        handles.PRange = [0 1];
    case 5 then
        // RMG
        handles.PData = pr - pg;
        handles.PRange = [-255 255];
    case 6 then
        // RMB
        handles.PData = pr - pb;
        handles.PRange = [-255 255];
    case 7 then
        // GMB
        handles.PData = pg - pb;
        handles.PRange = [-255 255];
    case 8 then
        // NRGVI
        ss = pr + pg;
        ss(ss==0) = 1;
        handles.PData = (pr - pg)./ss;
        handles.PRange = [-1 1];
    case 9 then
        // NRBVI
        ss = pr + pb;
        ss(ss==0) = 1;
        handles.PData = (pr - pb)./ss;
        handles.PRange = [-1 1];
    case 10 then
        // NGBVI
        ss = pg + pb;
        ss(ss==0) = 1;
        handles.PData = (pg - pb)./ss;
        handles.PRange = [-1 1];
    case 11 then
        // NGRVI
        ss = pg + pr;
        ss(ss==0) = 1;
        handles.PData = (pg - pr)./ss;
        handles.PRange = [-1 1];
    case 12 then
        // NBRVI
        ss = pb + pr;
        ss(ss==0) = 1;
        handles.PData = (pb - pr)./ss;
        handles.PRange = [-1 1];
    case 13 then
        // NBGVI
        ss = pb + pg;
        ss(ss==0) = 1;
        handles.PData = (pb - pg)./ss;
        handles.PRange = [-1 1];
    case 14 then
        // WI (Woebbecke Index)
        ss = pr - pg;
        ss(ss==0) = 1;
        handles.PData = (pg - pb)./ss;
        handles.PRange = [-255 255];
    case 15 then
        // BI (Brightness Index) 
        handles.PData = ((pr.^2 + pg.^2 + pb.^2)/3).^0.5;
        handles.PRange = [0 255];
    case 16 then
        // RGCh
        ss = pr + pg + pb;
        ss(ss==0) = 1; 
        handles.PData = (pr - pg)./ss;
        handles.PRange = [-1 1];
    case 17 then
        // RBCh
        ss = pr + pg + pb;
        ss(ss==0) = 1; 
        handles.PData = (pr - pb)./ss;
        handles.PRange = [-1 1];
    case 18 then
        // GBCh
        ss = pr + pg + pb;
        ss(ss==0) = 1; 
        handles.PData = (pg - pb)./ss;
        handles.PRange = [-1 1];
    case 19 then
        // GRCh
        ss = pr + pg + pb;
        ss(ss==0) = 1; 
        handles.PData = (pg - pr)./ss;
        handles.PRange = [-1 1];
    case 20 then
        // BRCh
        ss = pr + pg + pb;
        ss(ss==0) = 1; 
        handles.PData = (pb - pr)./ss;
        handles.PRange = [-1 1];
    case 21 then
        // BGCh
        ss = pr + pg + pb;
        ss(ss==0) = 1; 
        handles.PData = (pb - pg)./ss;
        handles.PRange = [-1 1];
    case 22 then
        // MGRVI
        ss = pg.^2 + pr.^2;
        ss(ss==0) = 1; 
        handles.PData = (pg.^2 - pr.^2)./ss;
        handles.PRange = [-1 1];
    case 23 then
        // RGRI
        pg(pg==0) = 1; 
        handles.PData = pr./pg;
        handles.PRange = [0 255];
    case 24 then
        // BGRI
        pg(pg==0) = 1; 
        handles.PData = pb./pg;
        handles.PRange = [0 255];
    case 25 then
        // GLI or VDVI
        ss = 2*pg + pr + pb;
        ss(ss==0) = 1; 
        handles.PData = (2*pg - pr - pb)./ss;
        handles.PRange = [-1 1];
    case 26 then
        // VARI
        ss = pg + pr - pb;
        ss(ss==0) = 1; 
        handles.PData = (pg - pr)./ss;
        handles.PRange = [-255 255];
    case 27 then
        // ExR
        ss = pg + pr + pb;
        ss(ss==0) = 1;
        pr = pr./ss;
        pg = pg./ss;
        pb = pb./ss; 
        handles.PData = 1.4*pr - pg;
        handles.PRange = [-1 1.4];
    case 28 then
        // ExG
        ss = pg + pr + pb;
        ss(ss==0) = 1;
        pr = pr./ss;
        pg = pg./ss;
        pb = pb./ss; 
        handles.PData = 2*pg - pr - pb;
        handles.PRange = [-1 2];
    case 29 then
        // ExB
        ss = pg + pr + pb;
        ss(ss==0) = 1;
        pr = pr./ss;
        pg = pg./ss;
        pb = pb./ss; 
        handles.PData = 1.4*pb - pg;
        handles.PRange = [-1 1.4];
    case 30 then
        // ExGR = ExG - ExR
        // 2g - r - b - (1.4r - g) = 3g - 2.4r - b
        ss = pg + pr + pb;
        ss(ss==0) = 1;
        pr = pr./ss;
        pg = pg./ss;
        pb = pb./ss; 
        handles.PData = 3*pg - 2.4*pr - pb;
        handles.PRange = [-2.4 3];
    else
        // Failsafe feedback
        messagebox("Unknown option.","Error","error","modal");
    end
    ShowPicture(handles);
    handles = resume(handles);
endfunction

// Save report of data
function fnSaveAllData(handles)
    // Scanning takes time, prevent user triggered event
    handles.lbPicType.enable = "off";
    // Exclude original color picture
    n = size(handles.PicTypes)(2) - 1;
    // Container of results
    RV = zeros(n,5);
    // Scanning all types
    for i = 1:n
        handles.lbPicType.value = 1 + i;
        // Progress indicator
        handles.hProgress.string = msprintf("Evaluating %d / %d",i,n);
        GetCMap(handles);
        RV(i,:) = handles.SData;
    end
    handles.hProgress.string = "Saving results to *-data.csv";
    // Saving data into CSV file
    saveName = msprintf("%s-data.csv",handles.FName);
    [fd, err] = mopen(saveName,"at");
    if err == 0 then
        // Print header
        for i = 1:n
            mfprintf(fd,"%s;",handles.PicTypes(1+i));
        end
        mfprintf(fd,"\n");
        // Print data
        for j = 1:5
            for i = 1:n
                mfprintf(fd,"%f;",RV(i,j));
            end
            mfprintf(fd,"\n");
        end
        mclose(fd);
    else
        messagebox("Error saving data!","Error","error","modal");
    end
    // Reset progress indicator and enable user selection
    handles.hProgress.string = "";
    handles.lbPicType.enable = "on";
    handles = resume(handles);
endfunction
