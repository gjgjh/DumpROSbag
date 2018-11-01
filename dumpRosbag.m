function dumpRosbag
% This function extract images and IMU from a ROS bagfile. It is based on Matlab Robotics Toolbox.
% The images will be named according to its timestamp. It will be sabed in .png format.
% The Imu data will be saved in .xls format.

% Load bagfile
[FileName,PathName] = uigetfile('*.bag');
bagfilename=[PathName FileName];
bag=rosbag(bagfilename);
IMGs=select(bag,'MessageType','sensor_msgs/Image');
IMUs=select(bag,'MessageType','sensor_msgs/Imu');

% Image
for i=1:IMGs.NumMessages
    img_tmp=readMessages(IMGs,i); % read i-th image
    img=readImage(img_tmp{1,1});
    
    imgtimestr=[num2str(img_tmp{1,1}.Header.Stamp.Sec) '.' num2str(img_tmp{1,1}.Header.Stamp.Nsec)];
    imgtime=str2num(imgtimestr); % read i-th image's timestamp
    
    imwrite(img,[imgtimestr '.png']) % save image file
end

disp('Images All Saved!');

% IMU
xlsresult={'TimeStamp' 'AngularVelocityX' 'AngularVelocityY' 'AngularVelocityZ' 'LinearAccelerationX' 'LinearAccelerationY' 'LinearAccelerationZ'};
for i=1:IMUs.NumMessages
    imu_tmp=readMessages(IMUs,i); % read i-th imu
    AngularVelocityX=imu_tmp{1,1}.AngularVelocity.X;
    AngularVelocityY=imu_tmp{1,1}.AngularVelocity.Y;
    AngularVelocityZ=imu_tmp{1,1}.AngularVelocity.Z;
    LinearAccelerationX=imu_tmp{1,1}.LinearAcceleration.X;
    LinearAccelerationY=imu_tmp{1,1}.LinearAcceleration.Y;
    LinearAccelerationZ=imu_tmp{1,1}.LinearAcceleration.Z;
    
    imutimestr=[num2str(imu_tmp{1,1}.Header.Stamp.Sec) '.' num2str(imu_tmp{1,1}.Header.Stamp.Nsec)];
    imutime=str2num(imutimestr); % read i-th imu's timestamp
    
    xlsresult(i+1,:)={imutimestr AngularVelocityX AngularVelocityY AngularVelocityZ LinearAccelerationX LinearAccelerationY LinearAccelerationZ};   
end
xlswrite('imu.xls',xlsresult);

disp('IMU All Saved!');
disp('Done :)');