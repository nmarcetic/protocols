# Mainflux IIoT Protocol Adapters

[![build][ci-badge]][ci-url]
[![go report card][grc-badge]][grc-url]
[![coverage][cov-badge]][cov-url]
[![license][license]](LICENSE)
[![chat][gitter-badge]][gitter]


Repository contains set of micro services for Mainflux IIoT supported protocols.
 Each protocol adapter provides API for sending messages through the Mainflux IIoT platform.


## Prerequisites

Running Mainflux IIoT [Core Platform](https://github.com/mainflux/mainflux) 

### For native install
Go (version 1.13.3)

### For running docker composition
* [Docker](https://docs.docker.com/install/) (version 18.09)
* [Docker compose](https://docs.docker.com/compose/install/)


## Install

### Native
Per protocol
```
make <protocol_name>
```
To install all supported protocls adapters
```
make all
```

## Docker
**Once the prerequisites are satisfied**, execute the following commands from the project's root:


**To run specific protocol**

* For Lora, run  `make runlora`
* For OPCUA, run `make runopcua`
* For CoAP, run `make runcoap`
* For Websocket, run `make runws` 


**To run all protocols**

`make runall` 

This command is executed using the project's included Makefile.
You can also run specific protocol with docker-compose command 
```                                                                                            
docker-compose -f docker/<protocol>-adapter/docker-compose.yml up

```

## Documentation
Official Mainflux documentation is hosted at [Mainflux Read The Docs page][docs].
You can find protocols explained on following links:


* [Lora](doc-lora)
* [CoAP](doc-coap)
* [OPC-UA](doc-opcua)
* [Websocket](doc-ws)

## License
[Apache-2.0](LICENSE)


[banner]: https://github.com/mainflux/docs/blob/master/docs/img/gopherBanner.jpg
[ci-badge]: https://semaphoreci.com/api/v1/mainflux/mainflux/branches/master/badge.svg
[ci-url]: https://semaphoreci.com/mainflux/mainflux
[docs]: http://mainflux.readthedocs.io
[docker]: https://www.docker.com
[forum]: https://groups.google.com/forum/#!forum/mainflux
[gitter]: https://gitter.im/mainflux/mainflux?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge
[gitter-badge]: https://badges.gitter.im/Join%20Chat.svg
[grc-badge]: https://goreportcard.com/badge/github.com/mainflux/protocols
[grc-url]: https://goreportcard.com/report/github.com/mainflux/protocols
[cov-badge]: https://codecov.io/gh/mainflux/protocols/branch/master/graph/badge.svg
[cov-url]: https://codecov.io/gh/mainflux/protocols
[license]: https://img.shields.io/badge/license-Apache%20v2.0-blue.svg
[doc-lora]: https://mainflux.readthedocs.io/en/latest/lora/
[doc-coap]: https://mainflux.readthedocs.io/en/latest/messaging/#coap 
[doc-opcua]: https://mainflux.readthedocs.io/en/latest/opcua/
[doc-ws]: https://mainflux.readthedocs.io/en/latest/messaging/#websocket