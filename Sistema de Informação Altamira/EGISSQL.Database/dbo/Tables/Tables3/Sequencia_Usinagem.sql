CREATE TABLE [dbo].[Sequencia_Usinagem] (
    [cd_sequencia_usinagem] INT          NOT NULL,
    [nm_sequencia_usinagem] VARCHAR (50) NULL,
    [sg_sequencia_usinagem] CHAR (15)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_rasgo_placa]        CHAR (1)     NULL,
    CONSTRAINT [PK_Sequencia_Usinagem] PRIMARY KEY CLUSTERED ([cd_sequencia_usinagem] ASC) WITH (FILLFACTOR = 90)
);

