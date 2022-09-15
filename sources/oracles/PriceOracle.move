address Quantum {

module PriceOracle {
    use Quantum::Math;
    use Quantum::Oracle::{Self, DataRecord, UpdateCapability};

    struct PriceOracleInfo has copy,store,drop{
        scaling_factor: u128,
    }

    public fun register_oracle<OracleT: copy+store+drop>(sender: &signer, precision: u8){
        let scaling_factor = Math::pow(10, (precision as u64));
        Oracle::register_oracle<OracleT, PriceOracleInfo>(sender, PriceOracleInfo{
            scaling_factor,
        });
    }

    public fun init_data_source<OracleT: copy+store+drop>(sender: &signer, init_value: u128){
        Oracle::init_data_source<OracleT, PriceOracleInfo, u128>(sender, init_value);
    }

    public fun is_data_source_initialized<OracleT:  copy+store+drop>(ds_addr: address): bool{
        Oracle::is_data_source_initialized<OracleT, u128>(ds_addr)
    }

    public fun get_scaling_factor<OracleT: copy + store + drop>() : u128 {
        let info = Oracle::get_oracle_info<OracleT, PriceOracleInfo>();
        info.scaling_factor
    }

    public fun update<OracleT: copy+store+drop>(sender: &signer, value: u128){
        Oracle::update<OracleT, u128>(sender, value);
    }

    public fun update_with_cap<OracleT: copy+store+drop>(cap: &mut UpdateCapability<OracleT>, value: u128) {
        Oracle::update_with_cap<OracleT, u128>(cap, value);
    }

    public fun read<OracleT: copy+store+drop>(addr: address) : u128{
        Oracle::read<OracleT, u128>(addr)
    }

    public fun read_record<OracleT:copy+store+drop>(addr: address): DataRecord<u128>{
        Oracle::read_record<OracleT, u128>(addr)
    }

    public fun read_records<OracleT:copy+store+drop>(addrs: &vector<address>): vector<DataRecord<u128>>{
        Oracle::read_records<OracleT, u128>(addrs)
    }
}
}