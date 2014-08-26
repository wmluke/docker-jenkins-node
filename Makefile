
install:
	docker build -t wmluke/jenkins-slave .

clean:
	docker rm -f jenkins-slave

run:
	docker run -d -p 2223:22 -v /home/docker/.ssh:/home/jenkins/.ssh --name jenkins-slave wmluke/jenkins-slave
