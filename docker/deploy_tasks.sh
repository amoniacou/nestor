#!/bin/bash
DEPLOY_TASKS="db:migrate"
echo "Running deploy tasks: bundle exec rake $DEPLOY_TASKS"
cd /home/app/webapp && bundle exec rake $DEPLOY_TASKS
