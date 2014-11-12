CREATE TABLE [dbo].[Componente_Sistema] (
    [cd_componente_sistema] INT          NOT NULL,
    [nm_componente_sistema] VARCHAR (30) NOT NULL,
    [sg_componente_sistema] CHAR (15)    NOT NULL,
    [ic_orcamento_sistema]  CHAR (1)     NOT NULL,
    [cd_tipo_componente]    INT          NULL,
    [cd_ordem_sistema]      INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Componente_Sistema] PRIMARY KEY NONCLUSTERED ([cd_componente_sistema] ASC) WITH (FILLFACTOR = 90)
);

