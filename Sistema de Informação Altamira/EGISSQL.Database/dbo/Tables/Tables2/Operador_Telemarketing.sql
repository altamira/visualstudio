CREATE TABLE [dbo].[Operador_Telemarketing] (
    [cd_operador_telemarketing] INT          NOT NULL,
    [nm_operador_telemarketing] VARCHAR (30) NULL,
    [sg_operador_telemarketing] CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_vendedor]               INT          NULL,
    CONSTRAINT [PK_Operador_Telemarketing] PRIMARY KEY CLUSTERED ([cd_operador_telemarketing] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operador_Telemarketing_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

