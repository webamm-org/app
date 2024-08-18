import { application } from "./application"

import AccordionController from './accordion_controller'
application.register('accordion', AccordionController)

import ColumnController from './column_controller'
application.register('column', ColumnController)

import IndexController from './index_controller'
application.register('index', IndexController)

import AssociationController from './association_controller'
application.register('association', AssociationController)

import MenuController from './menu_controller'
application.register('menu', MenuController)

import ResourceController from './resource_controller'
application.register('resource', ResourceController)

import AuthorizationController from './authorization_controller'
application.register('authorization', AuthorizationController)
