// 3D point cloud visualization with temperature data
// CSV file (ASCII text) processing

// Create application window
f = figure("figure_size", [1000 600], ...
    "figure_name", "3D Temperature Visualization", ...
    "dockable","off", ...
    "infobar_visible","off", ...
    "toolbar_visible","off", ...
    "menubar_visible","off", ...
    "default_axes","on", ...
    "auto_resize","on");
// avoid warning message of function update
funcprot(0);

// Create user interface
handles.dummy = 0;
handles.ChartFrame = uicontrol(f, ..
    "style", "frame", ...
    "units", "normalized", ...
    "position", [0.05 0.05 0.75 0.95]);
handles.pbOpen1 = uicontrol(f, ...
    "tag", "pbOpen1", ...
    "style", "pushbutton", ...
    "string", "Open field CSV", ...
    "units", "normalized", ...
    "position", [0.82 0.9 0.16 0.06], ...
    "callback", "pbOpen(handles,1)");
handles.pbOpen2 = uicontrol(f, ...
    "tag", "pbOpen2", ...
    "style", "pushbutton", ...
    "string", "Open tree CSV", ...
    "units", "normalized", ...
    "position", [0.82 0.8 0.16 0.06], ...
    "callback", "pbOpen(handles,2)");
handles.sAngle1 = uicontrol(f, ...
    "tag", "sAngle1", ...
    "style", "slider", ...
    "min", [-90], "max", [90], "value", [30], "sliderstep", [1 5], ...
    "units", "normalized", ...
    "position", [0.05 0 0.75 0.05], ...
    "callback", "Rotate(handles)");
handles.sAngle2 = uicontrol(f, ...
    "tag", "sAngle2", ...
    "style", "slider", ...
    "min", [0], "max", [180], "value", [30], "sliderstep", [1 5], ...
    "units", "normalized", ...
    "position", [0 0.05 0.05 0.95], ...
    "callback", "Rotate(handles)");
handles.infoMarker = uicontrol(f, ...
    "style", "text", ...
    "string", "Marker style", ...
    "units", "normalized", ...
    "position", [0.82 0.66 0.16 0.06]);
handles.rbCircle = uicontrol(f, ...
    "style", "radiobutton", ...
    "units", "normalized", ...
    "position", [0.82 0.60 0.16 0.06], ...
    "string", "Transparent", ...
    "min", [0], "max", [1], "value", [0], ...
    "groupname", "mymarkers", ...
    "callback", "ChangeMarkerStyle(handles,1)");
handles.rbBall = uicontrol(f, ...
    "style", "radiobutton", ...
    "units", "normalized", ...
    "position", [0.82 0.54 0.16 0.06], ...
    "string", "Colormap circles", ...
    "min", [0], "max", [1], "value", [0], ...
    "groupname", "mymarkers", ...
    "callback", "ChangeMarkerStyle(handles,2)");
handles.rbColorMap = uicontrol(f, ...
    "style", "radiobutton", ...
    "units", "normalized", ...
    "position", [0.82 0.48 0.16 0.06], ...
    "string", "Colormap balls", ...
    "min", [0], "max", [1], "value", [1], ...
    "groupname", "mymarkers", ...
    "callback", "ChangeMarkerStyle(handles,3)");
handles.infoMax = uicontrol(f, ...
    "style", "text", ...
    "string", "Maximum, °C", ...
    "units", "normalized", ...
    "position", [0.82 0.4 0.1 0.06]);
handles.edMax = uicontrol(f, ...
    "style", "edit", ...
    "tag", "edMax", ...
    "string", "0", ...
    "horizontalalignment", "right", ...
    "enable", "off", ...
    "units", "normalized", ...
    "position", [0.92 0.4 0.06 0.06]);
handles.infoAvg = uicontrol(f, ...
    "style", "text", ...
    "string", "Average, °C", ...
    "units", "normalized", ...
    "position", [0.82 0.34 0.1 0.06]);
handles.edAvg = uicontrol(f, ...
    "style", "edit", ...
    "tag", "edAvg", ...
    "string", "0", ...
    "horizontalalignment", "right", ...
    "enable", "off", ...
    "units", "normalized", ...
    "position", [0.92 0.34 0.06 0.06]);
handles.infoMin = uicontrol(f, ...
    "style", "text", ...
    "string", "Minimum, °C", ...
    "units", "normalized", ...
    "position", [0.82 0.28 0.1 0.06]);
handles.edMin = uicontrol(f, ...
    "style", "edit", ...
    "tag", "edMin", ...
    "string", "0", ...
    "horizontalalignment", "right", ...
    "enable", "off", ...
    "units", "normalized", ...
    "position", [0.92 0.28 0.06 0.06]);
handles.infoStd = uicontrol(f, ...
    "style", "text", ...
    "string", "St.Dev., °C", ...
    "units", "normalized", ...
    "position", [0.82 0.22 0.1 0.06]);
handles.edStd = uicontrol(f, ...
    "style", "edit", ...
    "tag", "edStd", ...
    "string", "0", ...
    "horizontalalignment", "right", ...
    "enable", "off", ...
    "units", "normalized", ...
    "position", [0.92 0.22 0.06 0.06]);

// Set default values
// file name
handles.FName = "";
// failsafe dataset
handles.myData = zeros(1,3);
// rotation angle - horizontal
handles.Angle1 = 60;
// rotation angle - vertical
handles.Angle2 = 30;
// figure ID failsafe default
handles.myfigure = 0;
// marker style, default = colormap
handles.markerstyle = 3;
// data columns XYZ coordinates and value
handles.cx = 2;
handles.cy = 3;
handles.cz = 4;
handles.cv = 5;
// data table type - field or single tree
handles.datatype = 1;

//
// Functions
//

// Open text data file
function pbOpen(handles,ftype)
 [FileName,PathName,FilterIndex] = uigetfile(["*.dat|*.DAT|*.txt|*.TXT|*.csv|*.CSV", "ASCII text file (tab, txt, csv)"]);
 if FilterIndex == 0 then
     messagebox("No file was selected.","Error","error","modal");
     return;
 end
 if ftype ==1 then
     tmp = csvRead(fullfile(PathName, FileName),';',',','double',[],[],[],1);
 elseif ftype == 2 then
     tmp = csvRead(fullfile(PathName, FileName),' ','.','double');
 else
     messagebox("Invalid data type selection.","Error","error","modal");
     return;
 end
 handles.FName = FileName;
 handles.myData = tmp;
 if ftype == 1 then
     handles.cx = 2;
     handles.cy = 3;
     handles.cz = 4;
     handles.cv = 5;
     handles.datatype = 1;
 elseif ftype == 2 then
     handles.cx = 1;
     handles.cy = 2;
     handles.cz = 3;
     handles.cv = 5;
     handles.datatype = 2;
 end
 // Show chart
 ShowChart(handles);
 // Save for global use
 handles = resume(handles);
endfunction

// Make figure of selected slice
function ShowChart(handles)
 tmp = handles.myData;
 // data names
 dnames = ['Tree No.' 'LiDAR-X, m' 'LiDAR-Y, m' 'LiDAR-Z, m' 'Temperature, ªC'];
 // clear figure
 myaxes = newaxes(handles.ChartFrame);
 clf(handles.ChartFrame);
 XD = tmp(:,handles.cy);
 YD = tmp(:,handles.cx);
 ZD = tmp(:,handles.cz);
 SS = tmp(:,handles.cv);
 // filter out measurement error = mean - 2 x sd
 tv = mean(SS) - 2*stdev(SS);
 XD = XD(SS>tv);
 YD = YD(SS>tv);
 ZD = ZD(SS>tv);
 SS = SS(SS>tv);
 // get basic data
 handles.edMax.string = msprintf("%5.2lf",max(SS));
 handles.edMin.string = msprintf("%5.2lf",min(SS));
 handles.edAvg.string = msprintf("%5.2lf",mean(SS));
 handles.edStd.string = msprintf("%5.2lf",stdev(SS));
 // colormap
 cmap = jetcolormap(21);
 cidx = 1+floor(20*(SS-min(SS))/(max(SS)-min(SS)));
 CC = ones(length(SS),3);
 for i = 1:length(SS)
  CC(i,:) = cmap(cidx(i),:);
 end
 // plot
 if handles.markerstyle == 1 then
  scatter3d(XD,YD,ZD);
 elseif handles.markerstyle == 2 then
  scatter3d(XD,YD,ZD,[],CC);
 else
  scatter3d(XD,YD,ZD,[],CC,"fill");
 end
 // set rotation
 handles.myfigure = gca();
 handles.myfigure.rotation_angles = [handles.Angle2, handles.Angle1];
 // captions
 xlabel(dnames(3));
 ylabel(dnames(2));
 zlabel(dnames(4));
 title(handles.FName);
 // Save for global use
 handles = resume(handles);
endfunction

// Rotate figure
function Rotate(handles)
 handles.Angle1 = 90 - handles.sAngle1.Value;
 handles.Angle2 = handles.sAngle2.Value;
 handles.myfigure.rotation_angles = [handles.Angle2, handles.Angle1];
 // Save for global use
 handles = resume(handles);
endfunction

// Switch chart marker types
function ChangeMarkerStyle(handles,newvalue)
 handles.markerstyle = newvalue;
 ShowChart(handles);
  // Save for global use
 handles = resume(handles);
endfunction
