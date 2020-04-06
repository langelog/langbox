# Remember to first cd to your working directory
# ...or change the $PWD to the directory that you want to use

$ docker run --rm -v $PWD:/app -p 1314:1314 \
  langelog/langbox:0.1.4_base \
  root --notebook --ip 0.0.0.0 --port 1314 --allow-root
  
