--所有的关卡设置都在main文件夹里
--如果想定制关卡自用，请在上传时选择非公开
--并注上原作者和模组链接，万分感谢
name = "Colosseum PT-BR"
description = "Construa seu próprio Coliseu em qualquer lugar do mundo."

author = "WIGFRID"
version = "1.1.6"
forumthread = ""

dst_compatible = true
dont_starve_compatible = true
reign_of_giants_compatible = true
shipwrecked_compatible = true
hamlet_compatible = true
all_clients_require_mod = true
api_version = 6

api_version_dst = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"
server_filter_tags = {"Colosseum"}
priority = 0

configuration_options =
{
    {
        name = "permission",
        label = "Permissão de construção",
        hover = "Apenas os administradores podem construir?",
        options =
        {
            {description = "sim", data = true},
            {description = "não", data = false},
        },
        default = true,
    },
    ------------------------------------------------
    {
        name = "ticket",
        label = "Ingressos necessários",
        hover = "Ingressos necessários para o desafio",
        options =
        {
            {description = "10 golds", data = 1},
            {description = "gemas do arco-íris", data = 2},
            {description = "coin box[myth]", data = 3},
        },
        default = 1,
    },
    ------------------------------------------------
    {
        name = "delay",
        label = "Intervalo de tempo",
        hover = "Intervalo de tempo entre dois níveis",
        options =
        {
            {description = "2s", data = 2},
            {description = "5s", data = 5},
            {description = "10s", data = 10},
            {description = "15s", data = 15},
        },
        default = 10,
    },
    ------------------------------------------------
    {
        name = "tagany",
        label = "TAG Campeão Easy",
        hover = "Ativa a tag para o vencedor do modo Pesadelo",
        options =
        {
            {description = "sim", data = true},
            {description = "não", data = false},
        },
        default = true,
    },
    {
        name = "taghard",
        label = "TAG Campeão Hard",
        hover = "Ativa a tag para o vencedor do modo Inferno",
        options =
        {
            {description = "sim", data = true},
            {description = "não", data = false},
        },
        default = true,
    },
    {
        name = "tagendless",
        label = "TAG Campeão Infinito - X",
        hover = "Ativa a tag para o vencedor do modo Infinito",
        options =
        {
            {description = "sim", data = true},
            {description = "não", data = false},
        },
        default = true,
    }
}
