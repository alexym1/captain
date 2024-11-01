### Build docker images
docker-build:
	@${ECHO} "${_BLUE}Build docker images...${_END}"
	@${ECHO} "${_CYAN}Build docker images: Rprecommit ...${_END}"
	(cd inst; ./docker.sh --build)
  	@${ECHO} "${_CYAN}Build docker images: Rprecommit ... OK${_END}"
	@${ECHO} "${_BLUE}Build docker images... OK${_END}"

### Run docker images
docker-run:
	@${ECHO} "${_BLUE}Run docker images...${_END}"
	@${ECHO} "${_CYAN}Run docker images: Rprecommit ...${_END}"
	(cd inst; ./docker.sh --run)
	@${ECHO} "${_CYAN}Run docker images: Rprecommit ... OK${_END}"
	@${ECHO} "${_BLUE}Run docker images... OK${_END}"

### Publish docker images
docker-publish:
	@${ECHO} "${_BLUE}Publish docker images...${_END}"
	@${ECHO} "${_CYAN}Publish docker images: Rprecommit ...${_END}"
	(cd inst; ./docker.sh --publish)
	@${ECHO} "${_CYAN}Publish docker images: Rprecommit ... OK${_END}"
	@${ECHO} "${_BLUE}Publish docker images... OK${_END}"
