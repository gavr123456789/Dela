package main

import (
	"os"
	"strconv"
	"fmt"
	_ "embed"

	"github.com/diamondburned/gotk4-adwaita/pkg/adw"
	"github.com/diamondburned/gotk4/pkg/gio/v2"
	"github.com/diamondburned/gotk4/pkg/gtk/v4"
)

//go:embed main.ui
var uiXML string

func main() {
	app := adw.NewApplication("com.github.gavr123456789.dela", gio.ApplicationFlagsNone)
	app.ConnectActivate(func() { activate(app) })

	if code := app.Run(os.Args); code > 0 {
		os.Exit(code)
	}
}

func activate(app *adw.Application) {
	builder := gtk.NewBuilderFromString(uiXML)

	// MainWindow and Button are object IDs from the UI file
	window := builder.GetObject("MainWindow").Cast().(*adw.ApplicationWindow)
	window.SetApplication(&app.Application)

	tab_view := builder.GetObject("tab_view").Cast().(*adw.TabView)
	button_new_tab := builder.GetObject("button_new_tab").Cast().(*gtk.Button)
	overview := builder.GetObject("overview").Cast().(*adw.TabOverview)
	button_overview := builder.GetObject("button_overview").Cast().(*gtk.Button)
	tab_count := 1


	
	overview.ConnectCreateTab(func() (tabPage *adw.TabPage) {
		return add_page(tab_view, &tab_count)
	})
	button_overview.ConnectClicked(func () {
		overview.SetOpen(true)
	})
	button_new_tab.Connect("clicked", func() {
		button_new_tab.SetLabel(strconv.Itoa(tab_count))
		add_page(tab_view, &tab_count)
	})

	// app.AddWindow(window)
	window.Present()
}

func add_page(tab_view *adw.TabView, tab_count *int) *adw.TabPage {
	title := fmt.Sprintf("Tab %d", *tab_count)
	page := create_page(title)
	
	tab_page := tab_view.Append(page)
	tab_page.SetTitle(title)
	tab_page.SetLiveThumbnail(true)
	
	*tab_count += 1
	return tab_page
}

func create_page(title string) *adw.StatusPage {
	page := adw.NewStatusPage()
	page.SetTitle(title)
	page.SetVExpand(true)
	return page
}