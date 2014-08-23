
install:
	docker build -t worksite/jenkins-slave .

clean:
	docker rm -f jenkins-slave

run:
	docker run -d -P --name jenkins-slave worksite/jenkins-slave
