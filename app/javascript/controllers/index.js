import { application } from "./application"

import AccordionController from './accordion_controller'
application.register('accordion', AccordionController)

import ColumnController from './column_controller'
application.register('column', ColumnController)

import IndexController from './index_controller'
application.register('index', IndexController)
