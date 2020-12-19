// Author: lbaranyai@github
// You can watch video at
// Youtube: https://youtu.be/Ufa2KAF6pVY

//
// Create Image Processing demo application
//
f = figure("figure_size", [1000 600], ...
    "figure_name", "Image Processing", ...
    "dockable","off", ...
    "infobar_visible","off", ...
    "toolbar_visible","off", ...
    "menubar_visible","off", ...
    "default_axes","on", ...
    "auto_resize","on");

//
// Create user interface
//
handles.dummy = 0;
handles.pbOpen = uicontrol(f, ...
    "tag", "pbOpen", ...
    "style", "pushbutton", ...
    "string", "Open file", ...
    "units", "normalized", ...
    "position", [0.82 0.9 0.16 0.06], ...
    "callback", "pbOpen(handles)");
handles.pbNormalize = uicontrol(f, ...
    "tag", "pbNormalize", ...
    "style", "pushbutton", ...
    "string", "Normalize", ...
    "units", "normalized", ...
    "position", [0.82 0.82 0.16 0.06], ...
    "callback", "pbNormalize(handles)");
handles.pbSegment = uicontrol(f, ...
    "tag", "pbSegment", ...
    "style", "pushbutton", ...
    "string", "Find red", ...
    "units", "normalized", ...
    "position", [0.82 0.74 0.16 0.06], ...
    "callback", "pbSegment(handles)");
handles.uiSlider = uicontrol(f, ...
    "tag", "uiSlider", ...
    "style", "slider" , ...
    "units", "normalized", ...
    "position", [0.82 0.68 0.16 0.06], ...
    "min", [0], "max", [1], "value", [0.5], "sliderstep", [0.05 0.1], ...
    "callback", "pbSegment(handles)");
// Picture area
handles.myPicture = newaxes();
handles.myPicture.margins = [0 0 0 0];
handles.myPicture.axes_bounds = [0 0 0.80 1];
handles.myPicture.auto_clear = "on";

//
// Functions
//

// Open file and show in window
function pbOpen(handles)
 [FileName,PathName,FilterIndex] = uigetfile(["*.jpg|*.jpeg|*.JPG|*.JPEG", "JPEG pictures"]);
 if FilterIndex == 0 then
     messagebox("No file was selected.","Error","error","modal");
     return;
 end
 tmp = imread(fullfile(PathName, FileName));
 imshow(tmp);
 // save image for session
 handles.PIC = tmp;
 handles = resume(handles);
endfunction

// Normalize colors if color image is available
function pbNormalize(handles)
 tmp = handles.PIC;
 Layers = 0;
 [Height,Width,Layers] = size(tmp);
 if Layers == 0 then
     messagebox("Non-color image matrix was selected!","Error","error","modal");
     return;
 end
 pr = double(tmp(:,:,1));
 pg = double(tmp(:,:,2));
 pb = double(tmp(:,:,3));
 ss = pr + pg + pb;
 ss(ss==0) = 1;
 tmp(:,:,1) = uint8(255*pr./ss);
 tmp(:,:,2) = uint8(255*pg./ss);
 tmp(:,:,3) = uint8(255*pb./ss);
 imshow(tmp);
endfunction

// Recognize tomatoes in the picture
function pbSegment(handles)
 tmp = handles.PIC;
 Layers = 0;
 [Height,Width,Layers] = size(tmp);
 if Layers == 0 then
     messagebox("Non-color image matrix was selected!","Error","error","modal");
     return;
 end
 pr = double(tmp(:,:,1));
 pg = double(tmp(:,:,2));
 pb = double(tmp(:,:,3));
 ss = pr + pg + pb;
 ss(ss==0) = 1;
 pr = pr./ss;
 threshold = get(handles.uiSlider,"value");
 pr(pr<threshold) = 0;
 pr(pr>0) = 1;
 pr = uint8(pr);
 for i = 1:3
     tmp(:,:,i) = pr .* tmp(:,:,i);
 end
 imshow(tmp);
endfunction
