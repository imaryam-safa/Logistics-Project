--TOP 5 DRIVERS WITH HIGHEST REVENUE PER MILE
select top 5 driver_id, round(sum(total_revenue/total_miles),2) as revenue_per_mile from driver_monthly_metrics
group by driver_id 
order by revenue_per_mile desc

--DRIVER WITH THE HIGHEST MILE PER GALLON
select top 1 driver_id, round(sum(total_miles/total_fuel_gallons),2) as mpg from driver_monthly_metrics
group by driver_id
order by mpg;

--LIST OF DRIVERS WITH BEST ON-TIME DELIVERY RATES
select top 10 driver_id, round(on_time_delivery_rate*100,1) as on_time_percent 
from driver_monthly_metrics
order by on_time_delivery_rate desc;

--CREATING A NEW 'DRIVER PERFORMANCE' TABLE
select *
into driver_perf
from (
	select driver_id, 
		sum(trips_completed) as total_trips, 
		sum(total_miles) as completed_miles, 
		round(sum(total_revenue)/1000000,2) as total_Revenue_Million, 
		round(sum(average_mpg),2) as mpg,
		round(avg(on_time_delivery_rate*100),1) as on_time_rate
	from driver_monthly_metrics
	group by driver_id
) s

--ARE SAFETY INCIDENTS INFLUENCED BY TENURE?
select 
	safety_incidents.driver_id,
	drivers.total_yoe,
	count(safety_incidents.incident_id) as total_incidents,
	safety_incidents.incident_type as incident_type
from drivers
right join safety_incidents
	on drivers.driver_id = safety_incidents.driver_id
group by safety_incidents.driver_id, drivers.total_yoe, incident_type
order by drivers.total_yoe desc, total_incidents desc

--DOES EXPERIENCE INFLUENCE ON-TIME RATES?
select 
	driver_monthly_metrics.driver_id,
	round(driver_monthly_metrics.on_time_delivery_rate*100, 2) as on_time_rate,
	drivers.years_experience as experience
from driver_monthly_metrics
join drivers
	on driver_monthly_metrics.driver_id = drivers.driver_id
order by experience desc, on_time_rate desc;

--ARE ON-TIME RATES AND FUEL EFFICIENCY OF A DRIVER INFLUENCED BY THEIR TENURE?
select 
	driver_monthly_metrics.driver_id, 
	drivers.total_yoe,
	round(avg(driver_monthly_metrics.on_time_delivery_rate*100),1) as on_time_rate,
	round(sum(driver_monthly_metrics.average_mpg), 2) as fuel_efficiency
from driver_monthly_metrics
join drivers
	on driver_monthly_metrics.driver_id = drivers.driver_id
group by driver_monthly_metrics.driver_id, drivers.total_yoe
order by drivers.total_yoe desc, on_time_rate desc;