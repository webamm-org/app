import { application } from "./application"

import AccordionController from './accordion_controller'
application.register('accordion', AccordionController)

import ColumnController from './column_controller'
application.register('column', ColumnController)
