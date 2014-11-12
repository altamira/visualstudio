CREATE TABLE [dbo].[Periculosidade] (
    [cd_periculosidade] INT          NOT NULL,
    [nm_periculosidade] VARCHAR (30) NULL,
    [sg_periculosidade] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Periculosidade] PRIMARY KEY CLUSTERED ([cd_periculosidade] ASC) WITH (FILLFACTOR = 90)
);

