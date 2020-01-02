.PHONY: install
install: rpi-monitor.sh rpi-monitor.service
	cp rpi-monitor.sh /usr/local/bin
	cp rpi-monitor.service /etc/systemd/system
	systemctl daemon-reload
	systemctl start rpi-monitor.service
	systemctl enable rpi-monitor.service
