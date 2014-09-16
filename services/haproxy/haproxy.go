package haproxy

import (
	"github.com/samuel/go-zookeeper/zk"

	conf "github.com/QubitProducts/bamboo/configuration"
	"github.com/QubitProducts/bamboo/services/marathon"
	"github.com/QubitProducts/bamboo/services/service"
)

type templateData struct {
	Apps    []marathon.App
	Services map[string]service.Service
}

func GetTemplateData(config *conf.Configuration, conn *zk.Conn) interface{} {

	apps, _ := marathon.FetchApps(config.Marathon.Endpoint)
	services, _ := service.All(conn, config.DomainMapping.Zookeeper)

	return templateData{ apps, services }
}
