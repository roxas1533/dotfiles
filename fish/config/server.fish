# Server-specific configuration (sub32)
# Only activate on server environment

# IntegratedView development server control
if test -d /var/www/IntegratedView
    function int --description "IntegratedView server control"
        switch $argv[1]
            case start
                sudo supervisorctl stop integrated_view
                and cd /var/www/IntegratedView/
                and /usr/bin/env sudo -E /var/www/IntegratedView/venv/bin/python /var/www/IntegratedView/manage.py runserver 0.0.0.0:8000 2>&1 | grep -v -e "DEBUG" -e "InsecureRequestWarning" -e "warnings" -e "b'" -e "botocore" -ie "aws" -e '^[0-9a-f]\{64\}$' -e "x-amz" -e "athena" -e'^/$' -e '^GET$' -e '^POST$' -e '^[0-9]\{8\}T[0-9]\{6\}Z$' -e '^$'
            case debug
                sudo supervisorctl stop integrated_view
                and cd /var/www/IntegratedView/
                and /usr/bin/env sudo -E /var/www/IntegratedView/venv/bin/python -m debugpy --listen localhost:5678 --wait-for-client /var/www/IntegratedView/manage.py runserver 0.0.0.0:8000 2>&1 | grep -v -e "DEBUG" -e "InsecureRequestWarning" -e "warnings" -e "b'" -e "botocore" -ie "aws" -e '^[0-9a-f]\{64\}$' -e "x-amz" -e "athena" -e'^/$' -e '^GET$' -e '^POST$' -e '^[0-9]\{8\}T[0-9]\{6\}Z$' -e '^$'
            case debug-no
                sudo supervisorctl stop integrated_view
                and cd /var/www/IntegratedView/
                and /usr/bin/env sudo -E /var/www/IntegratedView/venv/bin/python -m debugpy --listen localhost:5678 --wait-for-client /var/www/IntegratedView/manage.py runserver 0.0.0.0:8000 --nothreading 2>&1 | grep -v -e "DEBUG" -e "InsecureRequestWarning" -e "warnings" -e "b'" -e "botocore" -ie "aws" -e '^[0-9a-f]\{64\}$' -e "x-amz" -e "athena" -e'^/$' -e '^GET$' -e '^POST$' -e '^[0-9]\{8\}T[0-9]\{6\}Z$' -e '^$'
            case '*'
                echo "Usage: int [start|debug|debug-no]"
        end
    end
end

# mise (if available)
if test -x /usr/bin/mise
    /usr/bin/mise activate fish | source
end
