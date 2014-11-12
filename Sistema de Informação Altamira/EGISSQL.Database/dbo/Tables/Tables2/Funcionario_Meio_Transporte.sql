CREATE TABLE [dbo].[Funcionario_Meio_Transporte] (
    [cd_funcionario]              INT          NOT NULL,
    [cd_item_transporte]          INT          NOT NULL,
    [cd_meio_transporte]          INT          NOT NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [nm_obs_meio_transporte]      VARCHAR (40) NULL,
    [qt_passagem_meio_transporte] FLOAT (53)   NULL,
    [vl_meio_transporte]          FLOAT (53)   NULL,
    [qt_dia_meio_transporte]      FLOAT (53)   NULL,
    CONSTRAINT [PK_Funcionario_Meio_Transporte] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_item_transporte] ASC, [cd_meio_transporte] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Meio_Transporte_Meio_Transporte] FOREIGN KEY ([cd_meio_transporte]) REFERENCES [dbo].[Meio_Transporte] ([cd_meio_transporte])
);

