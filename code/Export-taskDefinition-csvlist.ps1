function Export-taskDefinition-csvlist {

   
    $awsprofile = $Env:awsprofile
    $resultpath = $Env:resultpath
    echo  $awsprofile
    #get all clusters
    $date = Get-Date -format "yyyyMMdd"
    #$profile = "tstdaccess"
    $outputfilename = "Results$awsprofile.fast.$date"

    $cluster_list_json = aws ecs list-clusters --profile $awsprofile|ConvertFrom-Json  #--cluster arn:aws:ecs:eu-west-3:894824635875:cluster/redis-sites-3

    $Results = @()
    $servicetdlist =@()

    $service_full_list = @()

    $i=0

    foreach($cluster in $cluster_list_json.clusterArns)
    {
    #write-host ("-c {0}" -f $cluster)
        echo "- $cluster"
        $start = 0
        $end = 9

        $service_list_json = aws ecs list-services --profile $awsprofile --cluster $cluster

        $service_list = $service_list_json |ConvertFrom-Json|   Select-Object -expand serviceArns

        $servicecount = $service_list.count
        
        ##preprocess
        write-host "--- $servicecount"

        
        while($start -le $servicecount )
        {
            echo "--t:$servicecount-s:$start e:$end"
            if($start+9 -gt $servicecount )
            {
                if($start -eq 0)
                {
                    $start = 0
                }
                $end = $servicecount         
            }
            
            $service_full_list = aws ecs describe-services --services $service_list[$start..$end] --profile $awsprofile --cluster $cluster  --query "services[*].[taskDefinition,serviceName]" |ConvertFrom-Json #--query "services[].taskDefinition" 


            foreach($svc in $service_full_list)
            {

                $containerDefinitions = aws ecs describe-task-definition --task-definition $svc[0] --query "taskDefinition.containerDefinitions[]" --profile $awsprofile  |ConvertFrom-Json #--query "taskDefinition.containerDefinitions[]"
            
                foreach($cd in $containerDefinitions )
                {
                $Results += [PSCustomObject] @{
                    Cluster = $cluster
                    Service = $svc[1]
                    taskDefinition = $svc[0]
                    name = $cd.name
                    image =  $cd.image
                    cpu = $cd.cpu
                    memory = $cd.memory
                    }#EndCustomObject          
                }
            } 
            
        $start =  $start+10
        $end = $start+9  
        }

    }

    $Results  | Export-Csv -Path  ~$resultpath/$outputfilename.csv -NoTypeInformation


}

Export-taskDefinition-csvlist 