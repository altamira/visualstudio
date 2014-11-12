CREATE TABLE [dbo].[Placa] (
    [cd_placa]                  INT          NOT NULL,
    [nm_placa]                  VARCHAR (40) NOT NULL,
    [sg_placa]                  CHAR (10)    NOT NULL,
    [nm_placa_ingles]           VARCHAR (40) NOT NULL,
    [cd_ordem_placa]            INT          NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [qt_prof_furo_broca]        FLOAT (53)   NULL,
    [qt_prof_furo_macho]        FLOAT (53)   NULL,
    [ic_calculo_largura_dimens] CHAR (1)     NULL,
    [ic_calculo_markup_mp]      CHAR (1)     NULL,
    [cd_ordem_area_referencia]  INT          NULL,
    [ic_cpc_placa]              CHAR (1)     NULL,
    [ic_processo_placa]         CHAR (1)     NULL,
    [cd_unidade_medida]         INT          NULL,
    CONSTRAINT [PK_Placa] PRIMARY KEY CLUSTERED ([cd_placa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Placa_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

