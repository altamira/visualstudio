CREATE TABLE [dbo].[APC_Parametro] (
    [cd_empresa]        INT           NOT NULL,
    [nm_local_origem]   VARCHAR (150) NULL,
    [cd_usuario]        INT           NULL,
    [dt_usuario]        DATETIME      NULL,
    [vl_divisor_income] FLOAT (53)    NULL,
    CONSTRAINT [PK_APC_Parametro] PRIMARY KEY CLUSTERED ([cd_empresa] ASC),
    CONSTRAINT [FK_APC_Parametro_Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

