module Wiki::PagesHelper
	def ordering_options_select_values
		[[t("views.page.order_by_date"), 0],[t("views.page.order_by_name"), 1]]
	end
end
