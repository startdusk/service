// Package v1 contains the full set of handler functions and routes
// supported by the v1 web api.
package v1

import (
	"net/http"

	"github.com/startdusk/service/app/services/sales-api/handlers/v1/testgrp"
	"github.com/startdusk/service/business/web/auth"
	"github.com/startdusk/service/business/web/v1/mid"
	"github.com/startdusk/service/foundation/web"
	"go.uber.org/zap"
)

// Config contains all the mandatory systems required by handlers.
type Config struct {
	Log  *zap.SugaredLogger
	Auth *auth.Auth
}

// Routes binds all the version 1 routes.
func Routes(app *web.App, cfg Config) {
	const version = "v1"

	tgh := testgrp.Handlers{
		Log: cfg.Log,
	}

	app.Handle(http.MethodGet, version, "/test", tgh.Test)
	app.Handle(http.MethodGet, version, "/testauth",
		tgh.Test, mid.Authenticate(cfg.Auth), mid.Authorize("ADMIN"))
}
