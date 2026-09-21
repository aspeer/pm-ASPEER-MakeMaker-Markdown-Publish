#  Markdown publication targets
#
PUBLISH_TARGETS=mkdocs_build mkdocs_serve mkdocs_gh_publish mkdocs_gh_push \
	vitepress_build vitepress_serve vitepress_gh_publish vitepress_gh_push \
	docusaurus_build docusaurus_serve docusaurus_gh_publish docusaurus_gh_push \
	starlight_build starlight_serve starlight_gh_publish starlight_gh_push


#  Always invoke publication targets even if a matching file exists
#
.PHONY: $(PUBLISH_TARGETS)

mkdocs_build ::
	@$(PUBLISH_PM_TARGET) publish mkdocs build

mkdocs_serve ::
	@$(PUBLISH_PM_TARGET) publish mkdocs serve

mkdocs_gh_publish ::
	@$(PUBLISH_PM_TARGET) publish mkdocs gh_publish

mkdocs_gh_push ::
	@$(PUBLISH_PM_TARGET) publish mkdocs gh_push

vitepress_build ::
	@$(PUBLISH_PM_TARGET) publish vitepress build

vitepress_serve ::
	@$(PUBLISH_PM_TARGET) publish vitepress serve

vitepress_gh_publish ::
	@$(PUBLISH_PM_TARGET) publish vitepress gh_publish

vitepress_gh_push ::
	@$(PUBLISH_PM_TARGET) publish vitepress gh_push

docusaurus_build ::
	@$(PUBLISH_PM_TARGET) publish docusaurus build

docusaurus_serve ::
	@$(PUBLISH_PM_TARGET) publish docusaurus serve

docusaurus_gh_publish ::
	@$(PUBLISH_PM_TARGET) publish docusaurus gh_publish

docusaurus_gh_push ::
	@$(PUBLISH_PM_TARGET) publish docusaurus gh_push

starlight_build ::
	@$(PUBLISH_PM_TARGET) publish starlight build

starlight_serve ::
	@$(PUBLISH_PM_TARGET) publish starlight serve

starlight_gh_publish ::
	@$(PUBLISH_PM_TARGET) publish starlight gh_publish

starlight_gh_push ::
	@$(PUBLISH_PM_TARGET) publish starlight gh_push
