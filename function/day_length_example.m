Day=0:365;

Lat_jeddah=21.4858;

hours_jeddah=day_length(Day,Lat_jeddah);

close all; figure(1)

plot(Day,hours_jeddah)
xlabel('Day (counting from December solstice)')
ylabel('length of daylight (hours)')
legend('Jeddah')
