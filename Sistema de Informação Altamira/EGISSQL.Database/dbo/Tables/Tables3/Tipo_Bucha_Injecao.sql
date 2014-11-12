CREATE TABLE [dbo].[Tipo_Bucha_Injecao] (
    [cd_tipo_bucha_injecao] INT           NOT NULL,
    [nm_tipo_bucha_injecao] VARCHAR (30)  NOT NULL,
    [sg_tipo_bucha_injecao] CHAR (10)     NOT NULL,
    [nm_desenho_vestigio]   VARCHAR (100) NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    CONSTRAINT [PK_Tipo_Bucha_Injecao] PRIMARY KEY NONCLUSTERED ([cd_tipo_bucha_injecao] ASC) WITH (FILLFACTOR = 90)
);

