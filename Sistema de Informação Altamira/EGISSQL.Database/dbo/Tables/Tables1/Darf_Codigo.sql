CREATE TABLE [dbo].[Darf_Codigo] (
    [cd_darf_codigo]   INT          NOT NULL,
    [sg_darf_codigo]   VARCHAR (5)  NOT NULL,
    [nm_darf_codigo]   VARCHAR (60) NULL,
    [cd_imposto]       INT          NULL,
    [ic_dirf]          CHAR (1)     NULL,
    [dt_validade_darf] DATETIME     NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Darf_Codigo] PRIMARY KEY CLUSTERED ([cd_darf_codigo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Darf_Codigo_Imposto] FOREIGN KEY ([cd_imposto]) REFERENCES [dbo].[Imposto] ([cd_imposto])
);

