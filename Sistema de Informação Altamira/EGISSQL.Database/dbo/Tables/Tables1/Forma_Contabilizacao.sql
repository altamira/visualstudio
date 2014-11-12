CREATE TABLE [dbo].[Forma_Contabilizacao] (
    [cd_forma_contabilizacao] INT          NOT NULL,
    [nm_forma_contabilizacao] VARCHAR (40) NULL,
    [sg_forma_contabilizacao] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Forma_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_forma_contabilizacao] ASC) WITH (FILLFACTOR = 90)
);

