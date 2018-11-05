
function mouseScratchLooming4(type,setupNum)
% sample: looming(1)
Screen('Preference', 'SkipSyncTests', 1);
% on a gray background, a black disc appeared directly above the animal at
% a diameter of 2 degrees of visual angle, expanded to 20 degrees in 250 ms,
% and remained at that size for 250 ms. This stimulus was repeated 15 times
% with 500 ms pauses.

% changetype: 1: non-change 2: topo-change 3: color-change 4: shape-change

% angleToPixel: 1 deg = distanceFromMonitor(cm)/57*28 pixels
% e.g. screen resolution: 1024*768, screen size 36.5cm*27.5cm
% 1 deg = 1 cm = 28 pixel for view distance 57 cm
% screen refresh rate: 60HZ or 100HZ
% update 20170920 add setup 2
% 27-Sep-2017 refPoint [0 0], former value [-320 0], y-coordinate of disk
% center is set to 0
% 4-Apirl-2018 add type 6 for THY

%% set parameters
close all;
clear all;
sca;

% scom1 = serial('COM3');% 改端口
% set(scom1, 'BaudRate', 9600, 'DataBits', 8, 'StopBits', 1, 'Parity', 'none', 'FlowControl', 'none');

% try
%     fopen(scom1);                               %打开串口
%     fprintf('串口打开成功。\n');
% catch err
%     fprintf('串口打开失败。\n');
% end

if ~exist('type','var')||isempty(type)
    type = 1;
end
if ~exist('setupNum','var')||isempty(setupNum)
    setupNum = 2;
end

%% prepare the serial port communication
global strRead;
global scom2;
scom2 = serial('com4');
% get(som)
set(scom2,'BaudRate',19200,'Parity','even','Terminator','NUL')
word = 'Start';
triggerWord = 'blink!';
% scom.BytesAvaibleFcnMode='byte';
% scom.BytesAvailableFcnCount=length(word)*2;
% scom.BytesAvailableFcn=@scomCallback;
% scom.RecordMode='append';
fopen(scom2);

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Disable Synctests
Screen('Preference','SkipSyncTests',1);

%% experiment parameters
% changeTime = 100; % the moment that stimuli changes
% changeDur = 80; % the change remains for 20ms
repeatTimes = 15; % stimili was repeated 15 times

fRate = FrameRate; % 60HZ
fRate = fix(fRate);
screenID = max(Screen('Screens'));
%%% color
stiColor = 0;
% changeColor = 255;
% color1 = [255 0 0];
% color2 = [0 255 0];
bg = 180;
blinkLumi = [0 128 255 128 0];
%%% time
switch type
    case -1 % no looming control
        stiDur = 250; % expanded in 250 ms
        remainDur = 250; % remained at that size for 250 ms
        pauseDur = 500; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 0; % 2 degrees
        endAngle = 0; % 20 degrees
    case 0 % stimuli used in Yilmaz & Meister 2013
        stiDur = 250; % expanded in 250 ms
        remainDur = 250; % remained at that size for 250 ms
        pauseDur = 500; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 20; % 20 degrees
    case 1 % stimuli used in Wei et al 2015
        stiDur = 250; % expanded in 250 ms
        remainDur = 50; % remained at that size for 50 ms
        pauseDur = 30; % stimili was repeated 15 times with 30 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 20; % 20 degrees   
    case 2 % stimuli used in our lab
        stiDur = 250; % expanded in 250 ms
        remainDur = 50; % remained at that size for 50 ms
        pauseDur = 30; % stimili was repeated 15 times with 30 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 40; % 20 degrees
    case 3
        repeatTimes = 1;
        stiDur = 1500; % expanded in 2.5 s
        remainDur = 1000; % remained at that size for 1000 ms
        pauseDur = 500; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 40; % 20 degrees
    case 4
        repeatTimes = 1;
        stiDur = 250; % expanded in 250 ms
        remainDur = 50; % remained at that size for 50 ms
        pauseDur = 30; % stimili was repeated 15 times with 30 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 40; % 20 degrees
    case 5
        repeatTimes = 1;
        stiDur = 350; % expanded in 3 s
        remainDur = 2150; % remained at that size for 250 ms
        pauseDur = 30; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 80; % 20 degrees
    case 6 % stimuli used by THY
        stiDur = 250; % expanded in 3 s
        remainDur = 50; % remained at that size for 250 ms
        pauseDur = 30; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 2; % 2 degrees
        endAngle = 40; % 20 degrees
    case 7 % no looming control
        stiDur = 250; % expanded in 250 ms
        remainDur = 250; % remained at that size for 250 ms
        pauseDur = 500; % stimili was repeated 15 times with 500 ms pauses
        startAngle = 0; % 2 degrees
        endAngle = 0; % 20 degrees
end
%%% size
% distanceFromMonitor = 57; % distance from the monitor to the guound
% angleToPixel = distanceFromMonitor/57*28;
% startAngle = 2; % 2 degrees
% endAngle = 30; % 20 degrees
% startSize = startAngle*angleToPixel;
% endSize = endAngle*angleToPixel;
switch setupNum
    case 0
        dMonitor2Ground = 335; % mm distance from the monitor to the ground
        screenHeight = 270; % mm
%         vResolution = 1024;
        rotMat = [0 -1;1 0];
        PIXEL2mm = 0.486; %  1920 pixels = 932.3 mm for touchscreen 1;
    case 1
        dMonitor2Ground = 415;
        screenHeight = 395;
%         vResolution = 1080;
        rotMat = [0 1;1 0];
        PIXEL2mm = 0.486; %  1920 pixels = 932.3 mm for touchscreen 1;
        refPoint = [0 0]';
    case 2
        dMonitor2Ground = 465;
        screenHeight = 525;
        %         vResolution = 1080;
        rotMat = [-1 0;0 1];
        PIXEL2mm = 0.486; %  1920 pixels = 932.3 mm for touchscreen 1;
        refPoint = [0 0]'; %[-320 0]';
end

%% the response key
KbName('UnifyKeyNames');
sKey = KbName('space');      % start every trial
qKey = KbName('escape');     % exit

%% prepare some windows
%%% main window
[window, screenRect] = Screen('OpenWindow', screenID , bg, [], 32);
screenRect
vResolution = screenRect(4)-screenRect(2);
hResolution = screenRect(3)-screenRect(1);
pMonitor2Ground = dMonitor2Ground*vResolution/screenHeight;

alpha = 0; % 0 front; pi back; pi/2 left; -pi/2 right; [] center;
shiftLength = tand(20)*pMonitor2Ground; % looming disk shifts 20 degree

%%% frame
nFrame = round(stiDur/1000*fRate)+1; % the whole frames
% changeFrame = round(changeTime/1000*fRate); % stimuli changes from this frame
% changeDurFrames = round(changeDur/1000*fRate);
% dSize = (endSize-startSize)/(nFrame-1); % degrees per frame
dAngle = linspace(startAngle, endAngle, nFrame);
% cenPoint = [screenRect(3)/2, screenRect(4)/2];

% %%% blank window
% blankWin = Screen('OpenOffscreenWindow', window, bg, screenRect);

%% present the stimuli
WaitSecs(1);
% frameWin = 1:nFrame;
isQuit = 0;
isBlink = false;
% for iloop = 1:nFrame
%     frameWin(iloop) = Screen('OpenOffScreenWindow', window, bg, screenRect);
% end
strRead = [];
while 1
%     Screen('DrawTexture', window, blankWin);
    Screen('FillRect', window, bg);
    Screen('Flip', window);
    while KbCheck; end
%     xShift=0;
%     yShift=0;
    posShift = [-hResolution/4;0];
%     pos = cenPoint;
    while 1
        if scom2.BytesAvailable>=1 %length(word)
            a = fscanf(scom2,'%c');
            strRead=[strRead a];
        end
        [keyIsDown, sec, keyCode] = KbCheck;
        if keyIsDown && keyCode(sKey)
            break;
        elseif keyIsDown && keyCode(qKey)
%             delete(scom1);
%             clear scom1;
            sca;
            isQuit = 1;
            break;
        elseif ~isempty(strRead) && contains(strRead, word) && contains(strRead, '!')
            tword = strRead(strfind(strRead, word):strfind(strRead, '!'))
            blankPos = strfind(tword,' ');
            if length(blankPos)==5
                x = str2double(tword(blankPos(1)+1:blankPos(2)-1));
                y = str2double(tword(blankPos(2)+1:blankPos(3)-1));
                xVector = str2double(tword(blankPos(3)+1:blankPos(4)-1));
                yVector = str2double(tword(blankPos(4)+1:blankPos(5)-1));
%                 switch setupNum
%                     case 0 % the former setup
%                         y = str2double(tword(blankPos(1)+1:blankPos(2)-1))*0.4929*1024/270;
%                         x = -str2double(tword(blankPos(2)+1:blankPos(3)-1))*0.4929*1024/270;
%                         yVector = str2double(tword(blankPos(3)+1:blankPos(4)-1));
%                         xVector = -str2double(tword(blankPos(4)+1:blankPos(5)-1));
%                     case 1 % the new setup
%                         y = -str2double(tword(blankPos(1)+1:blankPos(2)-1))*0.4929*1080/395;
%                         x = -str2double(tword(blankPos(2)+1:blankPos(3)-1))*0.4929*1080/395;
%                         yVector = -str2double(tword(blankPos(3)+1:blankPos(4)-1));
%                         xVector = -str2double(tword(blankPos(4)+1:blankPos(5)-1));
%                 end
                pos = rotMat*[x;y]*PIXEL2mm*vResolution/screenHeight;
%                 x = pos(1);
%                 y = pos(2);
                vector = rotMat*[xVector;yVector];
%                 xVector = vector(1);
%                 yVector = vector(2);
                if vector(1)~=0 % xVector~=0
%                     theta = atan(yVector/xVector);
                    theta = atan(vector(2)/vector(1));
                    if vector(1)<0 % xVector<0
                        theta = theta + pi;
                    end
                elseif vector(2)~=0 % yVector~=0
                    if vector(2)>0 % yVector>0
                        theta = pi/2;
                    else
                        theta = -pi/2;
                    end
                else
                    theta = [];
                end
                theta = theta + alpha;
                if ~isempty(theta)
%                     xShift = round(x+endSize*cos(theta));
%                     yShift = round(y+endSize*sin(theta));
                    posShift = round(pos+shiftLength*[cos(theta);sin(theta)]);
%                     posShift(2) = 0;
                else
%                     xShift = round(x);
%                     yShift = round(y);
                    posShift = [0;0];%round(pos);
                end
            end
             strRead = strrep(strRead, tword, '*');
             break;
        elseif ~isempty(strRead) && contains(strRead, triggerWord) && contains(strRead, '!')
            strRead = strrep(strRead, triggerWord, '#');
            isBlink = true;
             break;
        end
    end
    if isQuit
        Screen('CloseAll');
        ShowCursor;
        break;
    end
    if isBlink
%          fwrite(scom1, '1');      
        fprintf('event start。\n');
        for jloop = 1:fRate
            for kloop = 1:length(blinkLumi)
                Screen('FillRect', window, blinkLumi(kloop));
                Screen('Flip', window);
            end
        end
%         fwrite(scom1, '0');      
        fprintf('event stop。\n');
        isBlink = false;
    else
%         fwrite(scom1, '1');      
        fprintf('event start。\n');
        for jloop = 1:repeatTimes
            if type==7
                break;
            end
            
            for kloop = 1:nFrame
                diskAngle = dAngle(kloop);
                %             diskSize = startSize + dSize*(kloop-1);
                diskSize = round(2*pMonitor2Ground*tand(diskAngle/2));
                diskRect = [0 0 diskSize diskSize];
                %             rectShift = [xShift yShift xShift yShift];
                rectShift = [posShift' posShift'];
                %                     Screen('FillOval', frameWin(i), stiColor, rectShift+CenterRect(diskRect,screenRect));
                %                 Screen('FillOval', window, stiColor, rectShift+CenterRect(diskRect,screenRect));
                Screen('FillOval', window, stiColor, rectShift+CenterRect(diskRect,screenRect)+[refPoint' refPoint']);
                %                     Screen('DrawTexture', window, frameWin(i));
                Screen('Flip', window);
            end
             
            WaitSecs(remainDur/1000);
            %         Screen('DrawTexture', window, blankWin);
            Screen('FillRect', window, bg);
            Screen('Flip', window);
            WaitSecs(pauseDur/1000);
        end
%         fwrite(scom1, '0');      
        fprintf('event stop。\n');
    end
%     Screen('DrawTexture', window, blankWin);
    Screen('FillRect', window, bg);
    Screen('Flip', window);
end
fclose(scom2);
delete(scom2);
clear scom2
clear global
end