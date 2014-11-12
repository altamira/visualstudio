﻿CREATE TABLE [dbo].[Ordem_Servico_Tecnologia] (
    [cd_os_tecnologia]         INT          NOT NULL,
    [dt_os_tecnologia]         DATETIME     NULL,
    [nm_os_tecnologia]         VARCHAR (60) NULL,
    [ds_os_tecnologia]         TEXT         NULL,
    [cd_tipo_prioridade]       INT          NULL,
    [dt_baixa_os_tecnologia]   DATETIME     NULL,
    [dt_entrega_os_tecnologia] DATETIME     NULL,
    [cd_usuario]               INT          NULL,
    [cd_modulo]                INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_responsavel_usuario]   INT          NULL,
    CONSTRAINT [PK_Ordem_Servico_Tecnologia] PRIMARY KEY CLUSTERED ([cd_os_tecnologia] ASC) WITH (FILLFACTOR = 90)
);

