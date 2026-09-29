SELECT company,min(layoff_date) as first_layoff,max(layoff_date) as last_layoff,count(*) as num_events FROM layoffs 
group by company
order by num_events desc;
