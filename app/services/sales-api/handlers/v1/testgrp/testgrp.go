package testgrp

import (
	"context"
	"errors"
	"math/rand"
	"net/http"

	v1Web "github.com/startdusk/service/business/web/v1"
	"github.com/startdusk/service/foundation/web"
	"go.uber.org/zap"
)

// Handlers manages the set of check endpoints.
type Handlers struct {
	Log *zap.SugaredLogger
}

// Test handler is for development.
func (h *Handlers) Test(ctx context.Context, w http.ResponseWriter, r *http.Request) error {
	if n := rand.Intn(100); n%2 == 0 {
		return v1Web.NewRequestError(errors.New("trusted error"), http.StatusBadRequest)
	}
	status := struct {
		Status string
	}{
		Status: "ok",
	}

	return web.Respond(ctx, w, status, http.StatusOK)
}
