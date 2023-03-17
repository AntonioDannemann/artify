
// This file is auto-generated by ./bin/rails stimulus:manifest:update
// Run that command whenever you add a new controller or create them with
// ./bin/rails generate stimulus controllerName

import { application } from "./application"

import AosController from "./aos_controller"
application.register("aos", AosController)

import FlashesController from "./flashes_controller"
application.register("flashes", FlashesController)

import GeolocationController from "./geolocation_controller"
application.register("geolocation", GeolocationController)

import HomeLogoController from "./home_logo_controller"
application.register("home-logo", HomeLogoController)

import MapController from "./map_controller"
application.register("map", MapController)

import SearchFormController from "./search_form_controller"
application.register("search-form", SearchFormController)

import SwitchAccountFormController from "./switch_account_form_controller"
application.register("switch-account-form", SwitchAccountFormController)

import ToggleHiddenPasswordController from "./toggle_hidden_password_controller"
application.register("toggle-hidden-password", ToggleHiddenPasswordController)

import TutorialController from "./tutorial_controller"
application.register("tutorial", TutorialController)

import WindowEventsController from "./window_events_controller"
application.register("window-events", WindowEventsController)
