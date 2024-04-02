dlg {
    nam = "comp.dlg",
    noinv = true,
    calc = false,
    reports = false,
    goback = function(s)
        p(s.header)
        s:reset()
    end,
    next = function(s)
        walkback()
    end,
    hasCalc = function(s)
        return s.calc
    end,
    noCalc = function(s)
        return not s.calc
    end,
    hasReports  = function(s)
        return s.reports
    end,
    noReports = function(s)
        return not s.reports
    end,
    enter = function(s)
        p(s.header)
    end,
    header = "Управляющая оснастка ГКМ Эпсилон^Версия 12.3.445^^",
    disp = "Центральный вычислительный аппарат",
    phr = {
        { always = true, "> мониторинг", 
            function()
                return here().header
                    .."> мониторинг"
                    .."^Потребление памяти: "..rnd(55, 63).."%"
                    .."^Общая загрузка вычислительных блоков: "..rnd(9,12).."%"
                    .."^Загрузка нейронного блока: "..rnd(81,99).."%"
                    .."^Загрузка навигационного блока: 0%"
                    .."^Загрузка дисковой подсистемы: "..rnd(1,5).."%"
            end
        },
        { always = true, "> сервисы",
            function()
                local calcApp = ""
                if here().calc then
                    calcApp = "доступен"
                else
                    calcApp = "недоступен"
                end
                local reportsApp = ""
                if here().reports then
                    reportsApp = "доступен"
                else
                    reportsApp = "недоступен"
                end
                return here().header
                    .."> сервисы"
                    .."^Сервис мониторинга: доступен"
                    .."^Сервис управления правами: доступен"
                    .."^Сервис анализа навигационных данных: недоступен"
                    .."^Сервис отложенных вычислений: "..calcApp
                    .."^Сервис отчетов: "..reportsApp
            end,
            { always = true, "> отключить -сервис мониторинга",
                function()
                    return here().header
                        .."> отключить -сервис мониторинга"
                        .."^Ошибка! Недостаточно прав!"
                end
            },
            { always = true, "> отключить -сервис управления правами",
                function()
                    return here().header
                        .."> отключить -сервис управления правами"
                        .."^Ошибка! Недостаточно прав!"
                end
            },
            { always = true, "> включить -сервис анализа навигационных данных",
                function()
                    return here().header
                        .."> включить -сервис анализа навигационных данных"
                        .."^Ошибка! Невозможно включение сервиса анализа навигационных данных при статусе система I34-001!"
                end
            },
            { always = true, cond = util.act("noCalc"), "> включить -сервис отложенных вычислений",
                function()
                    here().calc = true
                    return here().header
                        .."> включить -сервис отложенных вычислений"
                        .."^Сервис отложенных вычислений включён."
                end
            },
            { always = true, cond = util.act("hasCalc"), "> выключить -сервис отложенных вычислений",
                function()
                    here().calc = false
                    return here().header
                        .."> выключить -сервис отложенных вычислений"
                        .."^Сервис отложенных вычислений выключен."
                end
            },
            { always = true, cond = util.act("noReports"), "> включить -сервис отчётов",
                function()
                    here().reports = true
                    return here().header
                        .."> включить -сервис отчётов"
                        .."^Сервис отчётов включён."
                end
            },
            { always = true, cond = util.act("hasReports"), "> выключить -сервис отчётов",
                function()
                    here().reports = false
                    return here().header
                        .."> выключить -сервис отчётов"
                        .."^Сервис отчётов выключен."
                end
            },
            { always = true, "> выход", util.act("goback") }
        },
        { always = true, cond = util.act("noReports"), "> операционные отчёты",
            function()
                return here().header
                    .."> операционные отчёты"
                    .."^Ошибка! Сервис отчётов недоступен!"
            end
        },
        { always = true, cond = util.act("hasReports"), "> операционные отчёты",
            function()
                return here().header
                    .."> операционные отчёты"
            end,
            { always = true, "> система жизнеобеспечения",
                function()
                    return here().header
                        .."> система жизнеобеспечения"
                        .."^Количество ошибок за последний цикл: 0"
                end
            },
            { always = true, "> гравитационные катушки", 
                function()
                    return here().header
                        .."> гравитационные катушки"
                        .."^Количество ошибок за последний цикл: 0"
                end 
            },
            { always = true, "> маршевый двигатель", 
                function()
                    return here().header
                        .."> маршевый двигатель"
                        .."^Количество ошибок за последний цикл: 0"
                end
            },
            { always = true, "> маневровые двигатели",
                function()
                    return here().header
                        .."> маневровые двигатели"
                        .."^Количество ошибок за последний цикл: 0"
                end
            },
            { always = true, "> система стыковки",
                function()
                    _("techroom").checked = true
                    return here().header
                        .."> система стыковки"
                        .."^Количество ошибок за последний цикл: 4"
                        .."^Внимание! Система стыковки заблокировано из-за ошибки с кодом U44-054!"
                end
            },
            { always = true, "> выход", util.act("goback") }
        },
        { always = true, "> выход", util.act("next") }
    }
}