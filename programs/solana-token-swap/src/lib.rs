use anchor_lang::prelude::*;

declare_id!("Gpr519D7rDwBFv9Lbk3nsNnoKeXCeu6hHJsfsHFhmEAT");

#[program]
pub mod solana_token_swap {
    use super::*;

    pub fn initialize(ctx: Context<Initialize>) -> Result<()> {
        msg!("Greetings from: {:?}", ctx.program_id);
        Ok(())
    }
}

#[derive(Accounts)]
pub struct Initialize {}
